To update the JSON
==================

* Log into Apple Developer Portal
* Go to "Certificates, Identifiers & Profiles", then "Identifiers" (https://developer.apple.com/account/resources/identifiers/list)
* Create a new identifier of type "Music IDs"
* Go to "Keys" (https://developer.apple.com/account/resources/authkeys/list)
* Create a new key of type "MusicKit" selecting the Music ID from third step
* Write down the Key ID and the Team ID (the first 10 characters from the reverse DNS TEAMID10CH.music.de.mydomain.myapp found in Enabled Services table)
* Download the certificate and save it in this folder with the name "AuthKey_ABCD123456.p8" where ABCD123456 is the Key ID
* Edit token.rb and update ISSUER_ID and KEY_ID with the correct Team ID and Key ID. Save it.
* Run "ruby token.rb" and copy the output token. It's gonna be valid for 20 minutes. You can change this expiration time up to 6 months, but you really should not.
* Open the AppleMusic.playground on Xcode (11.2 or later) and replace the token variable with the string from previous step.
* Run it.
