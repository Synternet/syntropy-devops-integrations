const mqtt = require("mqtt");
const client = mqtt.connect("mqtt://172.20.0.2:1883");

console.log("starting subscriber");

client.on("connect", function () {
  console.log("connected");

  client.subscribe("hello_syntropy", function (err) {
    if (!err) {
      console.log("[subscribed] endpoint: hello_syntropy");
    }
  });
});

client.on("message", function (topic, message) {
  // message is Buffer
  console.log(message.toString());
});
