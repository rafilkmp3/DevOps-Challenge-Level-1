import socket
import datetime
from flask import Flask, jsonify, request
app = Flask(__name__)


@app.route("/", methods=['GET'])
def index():

    # If you use Nginx behind other balancer, for instance AWS Application Balancer, HTTP_X_FORWARDED_FOR returns list of addresses.
    if 'X-Forwarded-For' in request.headers:
        proxy_data = request.headers['X-Forwarded-For']
        ip_list = proxy_data.split(',')
        user_ip = ip_list[0]  # first address in list is User IP
    else:
        user_ip = request.remote_addr

    return jsonify(timestamp=datetime.datetime.now().timestamp(),
                   engine="flask",
                   visitor_ip=user_ip,
                   hostname=socket.gethostname()), 200


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=9007)
