from flask import Flask, request, jsonify
from publish import run

app = Flask(__name__)

@app.route('/publish', methods=['POST'])
def publish_message():
    data = request.json
    topic = data.get('topic')
    message = data.get('message')
    qos = data.get('qos', 0)
    retain = data.get('retain', False)

    if not topic or not message:
        return jsonify({"error": "Topic and message are required"}), 400

    try:
        run(topic, message, qos, retain)
        return jsonify({"success": True, "message": f"Published to topic {topic}"})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)