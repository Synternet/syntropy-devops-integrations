const axios = require("axios");

const apiUrl = "https://geek-jokes.sameerkumar.website/api";
const fluentdUrl = "http://172.20.0.2:9880/joke";

async function fetchJoke() {
  try {
    const { data } = await axios.get(apiUrl);
    return data;
  } catch (error) {
    return "No joke this time...";
  }
}

setInterval(async () => {
  let joke = await fetchJoke();
  try {
    let res = await axios.post(fluentdUrl, { message: joke });
    console.log(res.status);
  } catch (error) {
    console.log(error);
  }
  console.log("logged: ", joke);
}, 30000);
