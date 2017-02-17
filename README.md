# Dial9

Dial9 allows me to allow specific people to access my apartment's callbox.

Once added to the list in `users.secrets.exs`, they can enable their number for a short time.

Dialing my apartment # on the callbox while they are enabled will dial their phone, instead of mine.

This is built using just Plug. I will probably refactor it to use ✨ Phoenix ✨ at some point.

## To do

Back-end:
- [x] Generate TwiML to forward call
- [x] Change number dialed based on user selection
- [x] Reset number dialed after set time
- [x] Streaming state using Server-Sent Events
- [ ] Users endpoint
- [ ] Secret-based SMS API
- [ ] Test suite
- [ ] Logging (email/SMS/file)

Web front end:
- [ ] UX/UI
- [ ] User selection
- [ ] Receive app state stream

Mobile front end:
- [ ] UX/UI
- [ ] User selection
- [ ] Receive app state stream

## Installation

Coming soon!
