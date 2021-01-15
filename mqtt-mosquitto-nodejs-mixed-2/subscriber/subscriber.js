const mqtt = require("mqtt");
const client = mqtt.connect("mqtt://172.20.0.2:1883");

console.log("Initializing Subscriber");

client.on("connect", function () {
  console.log("Established connection with Broker");

  client.subscribe("hello_syntropy", function (err) {
    if (!err) {
      console.log("[subscribed] topic: hello_syntropy");
    }
  });

  client.subscribe("init", function (err) {
    if (!err) {
      console.log("[subscribed] topic: init");
    }
  });

  client.subscribe("user_entry", function (err) {
    if (!err) {
      console.log("[subscribed] topic: init");
    }
  });
});

client.on("message", function (topic, message) {
  // message is Buffer so convert to a string
  console.log(`[received][${topic.toString()}] ${message.toString()}`);
});
