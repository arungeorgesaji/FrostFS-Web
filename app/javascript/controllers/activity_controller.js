function updateStats() {
  fetch('/files')
    .then(response => response.text())
    .then(html => {
      const parser = new DOMParser();
      const doc = parser.parseFromString(html, 'text/html');
      
      const stats = {
        total: Math.floor(Math.random() * 50) + 10,
        active: Math.floor(Math.random() * 20) + 5,
        frozen: Math.floor(Math.random() * 15) + 3
      };
      
      document.getElementById('file-count').textContent = stats.total;
      document.getElementById('active-count').textContent = stats.active;
      document.getElementById('frozen-count').textContent = stats.frozen;
    });
}

setInterval(updateStats, 5000);
updateStats(); 
