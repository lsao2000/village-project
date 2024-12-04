// const functions = require('firebase-functions');
// const admin = require('firebase-admin');
import * as functions from "firebase-functions";
import admin from "firebase-admin";
admin.initializeApp({
    credential: admin.credential.applicationDefault(),
});
//export const sendNotification = functions.firestore.onDocumentCreated(
//    'chats/{chatId}/messages/{messageId}',
//    (event) => {
//        console.log(event.data.data());
//    }
//);
export const sendNotification = functions.firestore
    .onDocumentCreated("chats/{chatId}/messages/{messageId}", (changes) => {
        console.log("----------------start function--------------------");

        const doc = changes.data.data();
        console.log(doc);

        const senderIdentification = doc.senderId;
        const contentMessage = doc.msgText;

        // Extract chatId from the context params
        const chatId = changes.params.chatId;

        // Retrieve the chat document to get userIds
        admin
            .firestore()
            .collection("chats")
            .doc(chatId)
            .get()
            .then((chatDoc) => {
                if (!chatDoc.exists) {
                    console.log("Chat document does not exist.");
                    return null;
                }

                const userIds = [
                    chatDoc.data().user1_id,
                    chatDoc.data().user2_id,
                ];
                const receiverId = userIds.find((id) =>
                    id !== senderIdentification
                ); // Determine receiverId

                if (!receiverId) {
                    console.log("Receiver ID not found.");
                    return null;
                }

                // Get push token for the receiver
                return admin
                    .firestore()
                    .collection("users")
                    .where("user_id", "==", receiverId)
                    .get()
                    .then((querySnapshot) => {
                        querySnapshot.forEach((userTo) => {
                            console.log(
                                `Found user to: ${userTo.data().firstName}`,
                            );
                            if (
                                userTo.data().pushToken &&
                                userTo.data().chatingWith !==
                                    senderIdentification
                            ) {
                                // Get info about the sender
                                admin
                                    .firestore()
                                    .collection("users")
                                    .where(
                                        "user_id",
                                        "==",
                                        senderIdentification,
                                    )
                                    .get()
                                    .then((querySnapshot2) => {
                                        querySnapshot2.forEach((userFrom) => {
                                            console.log(
                                                `Found user from: ${userFrom.data().firstName}`,
                                            );
                                            const payload = {
                                                notification: {
                                                    title:
                                                        `Message from "${userFrom.data().firstName}"`,
                                                    body: contentMessage,
                                                    //badge: "1",
                                                    //sound: "default",
                                                },
                                                token: userTo.data().pushToken,
                                            };

                                            // Send notification to the receiver
                                            admin
                                                .messaging()
                                                .send(payload)
                                                //.sendToDevice(userTo.data().pushToken, payload)
                                                .then((response) => {
                                                    console.log(
                                                        "Successfully sent message:",
                                                        response,
                                                    );
                                                })
                                                .catch((error) => {
                                                    console.log(
                                                        "Error sending message:",
                                                        error,
                                                    );
                                                });
                                        });
                                    });
                            } else {
                                console.log(
                                    "Cannot find pushToken for the target user or the user is chatting with the sender.",
                                );
                            }
                        });
                    });
            })
            .catch((error) => {
                console.log("Error retrieving chat document:", error);
            });

        return null;
    });

//  // .document('chat/{chatId}/messages/{messageId}')
