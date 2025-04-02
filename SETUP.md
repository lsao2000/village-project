## Agora Setup Notes
Working configuration:
- Flutter: Manual install (not Snap) <!--because you will get C++ & CMake building error if you installed with snap-->
- NDK: 21.4.7075529
- Agora SDK: 6.5.1
- Critical fix: Disabled pointer conversion warnings via CMake

## NodeJs Setup for generation Token in backend
Working configuration:
- Create node project that generate token using Agora app id and AppCertificate .
- run the server
- change the ip address to your current ip address in this file ./lib/controller/services/dio_services/http_services.dart
- now you can create a meeting in meeting page without these step you can't make any meeting.
