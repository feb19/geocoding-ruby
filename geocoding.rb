#encoding: utf-8
require 'net/http'
require 'json'
require 'nkf'

def doGeocoding(address)

    # 全角を半角に変換
    address = NKF::nkf('-WwZ0', address)

    url = { 
        :scheme => 'http',                # 今回使わない
        :server => 'maps.googleapis.com',
        :port   => 80,
        :path   => '/maps/api/geocode/json',
        :query  => 'address='+ address +'&sensor=true'
    };  

    # Google Map Geocoding API Access Sample
    begin
        Net::HTTP.start(url[:server], url[:port]) {|http|
            response = http.get(url[:path] + '?' + url[:query]);
            json = JSON.parse(response.body);
            result = json["results"][0];
            lat = result["geometry"]["location"]["lat"];
            lng = result["geometry"]["location"]["lng"];
            puts address + "\t" + lat.to_s + "\t" + lng.to_s
        }
    rescue Exception
        puts $!
    end

end

unless (ARGV[0].nil?)
    doGeocoding(ARGV[0]);
end
