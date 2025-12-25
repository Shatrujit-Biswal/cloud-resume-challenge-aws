const API_URL = "https://dsv95naia5.execute-api.ap-south-1.amazonaws.com/count";

async function updateVisitorCount() {
  try {
    const response = await fetch(API_URL);
    const data = await response.json();

    document.getElementById("visitor-count").innerText =
      `Visitors: ${data.count}`;
  } catch (error) {
    console.error("Error fetching visitor count:", error);
  }
}

updateVisitorCount();
