const API_URL = "__API_URL__";

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
