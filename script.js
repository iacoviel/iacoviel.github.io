// script.js
document.addEventListener('DOMContentLoaded', function() {
    // Fetch the Excel file
    fetch('shortage_index.xlsx')
        .then(response => response.arrayBuffer())
        .then(data => {
            const workbook = XLSX.read(data, { type: 'array' });
            const sheetName = workbook.SheetNames[0];
            const worksheet = workbook.Sheets[sheetName];
            const shortageData = XLSX.utils.sheet_to_json(worksheet, { header: 1 });

            // Extract dates and index values from the data
            const labels = shortageData.slice(1).map(row => row[0]);
            const indexValues = shortageData.slice(1).map(row => row[1]);

            // Create the chart
            const ctx = document.getElementById('shortageChart').getContext('2d');
            new Chart(ctx, {
                // ... (rest of the chart configuration remains the same)
            });
        })
        .catch(error => {
            console.error('Error fetching or parsing the Excel file:', error);
        });
});
