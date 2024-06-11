// script.js
document.addEventListener('DOMContentLoaded', function() {
    // Fetch the Excel file
    fetch('shortage_index.xlsx')
        .then(response => response.arrayBuffer())
        .then(data => {
            const workbook = XLSX.read(data, { type: 'array' });
            const sheetName = workbook.SheetNames[0];
            const worksheet = workbook.Sheets[sheetName];
            const shortageData = XLSX.utils.sheet_to_json(worksheet, { header: 1, cellDates: true });

            // Extract dates and index values from the data
            const labels = shortageData.slice(1).map(row => {
                const date = row[0];
                return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}`;
            });
            const indexValues = shortageData.slice(1).map(row => row[1]);

            // Create the chart
            const ctx = document.getElementById('shortageChart').getContext('2d');
            new Chart(ctx, {
                type: 'line',
                data: {
                    labels: labels,
                    datasets: [{
                        label: 'Shortage Index',
                        data: indexValues,
                        borderColor: 'blue',
                        fill: false
                    }]
                },
                options: {
                    responsive: true,
                    title: {
                        display: true,
                        text: 'Monthly Shortage Index (1900-2024)'
                    },
                    scales: {
                        x: {
                            display: true,
                            title: {
                                display: true,
                                text: 'Month'
                            }
                        },
                        y: {
                            display: true,
                            title: {
                                display: true,
                                text: 'Index Value'
                            }
                        }
                    }
                }
            });
        })
        .catch(error => {
            console.error('Error fetching or parsing the Excel file:', error);
        });
});
