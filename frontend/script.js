const API_URL = "__API_URL__";
const COUNT_ENDPOINT = API_URL.endsWith("/")
  ? `${API_URL}count`
  : `${API_URL}/count`;

async function updateVisitorCount() {
  try {
    const response = await fetch(COUNT_ENDPOINT);

    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }

    const data = await response.json();

    document.getElementById("visitor-count").innerText =
      `Visitors: ${data.count}`;
  } catch (error) {
    console.error("Error fetching visitor count:", error);
  }
}

updateVisitorCount();
