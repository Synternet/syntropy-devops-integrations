const mqtt = require("mqtt");
const client = mqtt.connect("mqtt://localhost:1883");

const CronJob = require("cron").CronJob;
const job = new CronJob(
  "1 * * * * *",
  function () {
    console.log("sending ping");
    client.publish("ping", `ping: ${Date.now()}`);
  },
  null,
  true,
  "America/New_York"
);

client.on("connect", function () {
  console.log("connected");
  client.publish("test", "Testing Connection");
  job.start();
});

client.on("message", function (topic, message) {
  // message is Buffer
  console.log(message.toString());
});
