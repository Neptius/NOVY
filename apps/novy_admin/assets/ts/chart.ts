import { Chart, registerables } from 'chart.js';
Chart.register(...registerables);


export const chart = {
    guest: 0,
    mounted() {
        this.handleEvent("points", ({points}) => {
            this.guest = points
        })

        var ctx = this.el.getContext("2d");
        var chartColor = "#FFFFFF";

        var gradientStroke = ctx.createLinearGradient(500, 0, 100, 0);
        gradientStroke.addColorStop(0, '#80b6f4');
        gradientStroke.addColorStop(1, chartColor);

        var gradientFill = ctx.createLinearGradient(0, 200, 0, 50);
        gradientFill.addColorStop(0, "rgba(128, 182, 244, 0)");
        gradientFill.addColorStop(1, "rgba(255, 255, 255, 0.24)");

        let chart = new Chart(ctx, {
            type: 'line',
            labels: [],
            data: {
                datasets: [{
                    label: "Visiteurs",
                    borderColor: chartColor,
                    pointBorderColor: chartColor,
                    pointBackgroundColor: "#1e3d60",
                    pointHoverBackgroundColor: "#1e3d60",
                    pointHoverBorderColor: chartColor,
                    pointBorderWidth: 1,
                    pointHoverRadius: 7,
                    pointHoverBorderWidth: 2,
                    pointRadius: 5,
                    fill: true,
                    backgroundColor: gradientFill,
                    borderWidth: 2,
                    data: [],
                    tension: 0.4
                }]
            },
            options: {
                maintainAspectRatio: false,
                layout: {
                    padding: {
                        left: 20,
                        right: 20,
                        top: 0,
                        bottom: 0
                    }
                },
                plugins: {
                    legend: {
                        position: "bottom",
                        fillStyle: "#FFF",
                        display: false
                    },
                    tooltips: {
                        backgroundColor: '#fff',
                        titleFontColor: '#333',
                        bodyFontColor: '#666',
                        bodySpacing: 4,
                        xPadding: 12,
                        mode: "nearest",
                        intersect: 0,
                        position: "nearest"
                    },
                },
                scales: {
                    y: {
                        ticks: {
                            color: "rgba(255,255,255,0.4)",
                            fontStyle: "bold",
                            beginAtZero: true,
                            maxTicksLimit: 5,
                            padding: 10
                        },
                        grid: {
                            drawTicks: true,
                            drawBorder: false,
                            display: true,
                            color: "rgba(255,255,255,0.1)",
                            zeroLineColor: "transparent"
                        }

                    },
                    x: {
                        grid: {
                            zeroLineColor: "transparent",
                            display: false,
                        },
                        ticks: {
                            padding: 10,
                            color: "rgba(255,255,255,0.4)",
                            fontStyle: "bold"
                        }
                    }
                }
            }
        });

        // const mainbloc = document.getElementById('main')

        // mainbloc.addEventListener("scroll", () => {
        //     let opacity = 0;
        //     const currentScroll = mainbloc.scrollTop;
        //     if (currentScroll <= 120) opacity = 1 - currentScroll / 120;
        //     this.el.style.opacity = opacity;
        // });

        setInterval(() => {
            let datas = chart.data.datasets[0].data;
            let labels = chart.data.labels;

            labels.push("");
            datas.push(this.guest);

            if (datas.length >= 20) {
                labels.shift()
                datas.shift();
            }

            chart.update();
        }, 500);
    }
}