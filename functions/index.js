/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

//const {onRequest} = require("firebase-functions/v2/https");
//const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendNotification = functions.firestore
  .document('chat/{chatId}/messages/{messageId}')
  .onCreate((snap, context) => {
    console.log('----------------start function--------------------');

    const doc = snap.data();
    console.log(doc);

    const senderIdentification = doc.senderId;
    const contentMessage = doc.msgText;

    // Extract chatId from the context params
    const chatId = context.params.chatId;

    // Retrieve the chat document to get userIds
    admin
      .firestore()
      .collection('chat')
      .doc(chatId)
      .get()
      .then(chatDoc => {
        if (!chatDoc.exists) {
          console.log('Chat document does not exist.');
          return null;
        }

        const userIds = [chatDoc.data().user1_id, chatDoc.data().user2_id];
        const receiverId = userIds.find(id => id !== senderIdentification); // Determine receiverId

        if (!receiverId) {
          console.log('Receiver ID not found.');
          return null;
        }

        // Get push token for the receiver
        return admin
          .firestore()
          .collection('users')
          .where('user_id', '==', receiverId)
          .get()
          .then(querySnapshot => {
            querySnapshot.forEach(userTo => {
              console.log(`Found user to: ${userTo.data().firstName}`);
              if (userTo.data().pushToken && userTo.data().chatingWith !== senderIdentification) {
                // Get info about the sender
                admin
                  .firestore()
                  .collection('users')
                  .where('user_id', '==', senderIdentification)
                  .get()
                  .then(querySnapshot2 => {
                    querySnapshot2.forEach(userFrom => {
                      console.log(`Found user from: ${userFrom.data().firstName}`);
                      const payload = {
                        notification: {
                          title: `Message from "${userFrom.data().firstName}"`,
                          body: contentMessage,
                          badge: '1',
                          sound: 'default',
                        },
                        // token:userTo.data().pushToken
                      };

                      // Send notification to the receiver
                      admin
                        .messaging()
                        // .send(payload)
                        .sendToDevice(userTo.data().pushToken, payload)
                        .then(response => {
                          console.log('Successfully sent message:', response);
                        })
                        .catch(error => {
                          console.log('Error sending message:', error);
                        });
                    });
                  });
              } else {
                console.log('Cannot find pushToken for the target user or the user is chatting with the sender.');
              }
            });
          });
      })
      .catch(error => {
        console.log('Error retrieving chat document:', error);
      });

    return null;
  });

