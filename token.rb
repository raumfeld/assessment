require "base64"
require "jwt"

ISSUER_ID = "YOUR APPLE TEAM ID WITH 10 CHARACTERS"
KEY_ID = "YOUR MUSICKIT KEY ID WITH 10 CHARACTERS"

private_key = OpenSSL::PKey.read(File.read("AuthKey_#{KEY_ID}.p8"))

token = JWT.encode({
    iss: ISSUER_ID,
    exp: Time.now.to_i + 20 * 60
   },
   private_key,
   "ES256",
   header_fields={
     kid: KEY_ID 
   }
 )
 
puts token
