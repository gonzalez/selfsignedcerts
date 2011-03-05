require 'rubygems'
require 'sinatra'
require 'Time'
require 'openssl'
require 'haml'

class Certificate
 def initialize(domain)
 puts @domain
 @domain = domain
 @key = OpenSSL::PKey::RSA.generate(2048)
 @pem = @key.public_key
 @ca = OpenSSL::X509::Name.parse("/C=US/ST=NewYork/L=NewYork/O=Organization/CN=#{@domain}")
 @cert = OpenSSL::X509::Certificate.new
 @cert.version = 2
 @cert.serial = 1
 @cert.subject = @ca
 @cert.issuer = @ca
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
   @key.to_pem
 end

 def pub
   @key.public_key.to_pem
 end
  
 def csr
   "csr goes here"
 end

end

get '/snakeoil/:domain' do
 n = Certificate.new(params[:domain])
 haml :index, :locals => {:cert => "#{n.cert}",:key => "#{n.key}",:domain => "#{n.domain}",:pub => "#{n.pub}",:csr => "#{n.csr}"}
end

__END__

@@ index
!!!  
%html  
  %head  
    %title Free Self Signed Certificates  
  %style{:type => "text/css", :media => "screen"}
    :plain
      p {
        font-family: sans;
        font-size: 1.2em;
        color: blue;
      }
      
  %body
    %div{:style => "width:700px; margin:5px; border-width:1px; border-color:black; border-style:coral;"}  
      %div
        %p
        %strong A self signed certificate has been generated for #{domain}  
      %div
        %strong Certificate
      %div
        %textarea{:style => "height:200px; width:500px;"} #{cert}
      %div
        %strong Private Key
      %div
        %textarea{:style => "height:380px; width:500px;"} #{key}
      %div 
        %strong Certificate Signing Request (CSR)
      %div
        %textarea{:style => "height:200px; width:500px;"} #{csr}
      %div 
        %strong pem file
      %div
        %textarea{:style => "height:500px; width:500px;"} #{pub} #{key}
















