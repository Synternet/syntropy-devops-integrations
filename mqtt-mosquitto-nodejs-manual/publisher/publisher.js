const mqtt = require("mqtt");
const moment = require("moment");
const client = mqtt.connect("mqtt://172.20.0.2:1883");

const CronJob = require("cron").CronJob;

// publish a message at 5minute intervals
const job = new CronJob(
  "5 * * * * *",
  function () {
    const time = moment().format("MMMM Do YYYY, h:mm:ss a");
    console.log(`[sending] ${time}`);
    client.publish("hello_syntropy", `Powered by SyntropyStack: ${time}`);
  },
  null,
  true,
  "America/New_York"
);

console.log("Initializing Publisher");

client.on("connect", function () {
  console.log("Established connection with Broker");
  client.publish("init", `Powered by SyntropyStack`);
  job.start();
});

client.on("message", function (topic, message) {
  // message is Buffer, so convert to string
  console.log(message.toString());
});
