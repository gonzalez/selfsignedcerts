require 'rubygems'
require 'sinatra'
require 'Time'
require 'openssl'

class Certificate
 def initialize(domain)
 puts @domain
 @domain = domain
 @key = OpenSSL::PKey::RSA.generate(2048)
 @pem = key.to_pem
 ca = OpenSSL::X509::Name.parse("/C=US/ST=NewYork/L=NewYork/O=Organization/CN=#{@domain}")
 @cert = OpenSSL::X509::Certificate.new
 @cert.version = 2
 @cert.serial = 1
 @cert.subject = ca
 @cert.issuer = ca
 @cert.public_key = @key.public_key
 @cert.not_before = Time.now
 @cert.not_after = Time.now + (360 * 24 * 3600)
 end

 def domain
   @domain
 end

 def cert
   @cert.to_pem
 end

 def key
   @key.public_key
 end

 def pem
   @pem
 end

end

get '/snakeoil/:domain' do
 n = Certificate.new(params[:domain])
 "Self-Signed Certificate Generated for: #{n.domain}  #{n.pem} /n #{n.cert}"
end