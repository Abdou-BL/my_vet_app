export class ToastNotification {
    constructor() {
        this.setupStyles();
        this.createToastContainer();
    }

    setupStyles() {
        const style = document.createElement('style');
        style.textContent = `
            .toast-container {
                position: fixed;
                top: 20px;
                right: 20px;
                z-index: 9999;
            }

            .toast {
                background: #4CAF50;
                color: white;
                padding: 15px 25px;
                border-radius: 8px;
                margin-bottom: 10px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.15);
                display: flex;
                align-items: center;
                justify-content: space-between;
                min-width: 300px;
                max-width: 500px;
                transform: translateX(120%);
                transition: transform 0.3s ease;
            }

            .toast.show {
                transform: translateX(0);
            }

            .toast.success {
                background: #4CAF50;
            }

            .toast.error {
                background: #f44336;
            }

            .toast.info {
                background: #2196F3;
            }

            .toast.warning {
                background: #ff9800;
            }

            .toast-close {
                background: none;
                border: none;
                color: white;
                cursor: pointer;
                font-size: 20px;
                padding: 0 0 0 15px;
            }

            .toast-progress {
                position: absolute;
                bottom: 0;
                left: 0;
                height: 3px;
                background: rgba(255,255,255,0.4);
                width: 100%;
                transition: width linear;
            }
        `;
        document.head.appendChild(style);
    }

    createToastContainer() {
        const container = document.createElement('div');
        container.className = 'toast-container';
        document.body.appendChild(container);
    }

    show(message, type = 'success', duration = 3000) {
        const container = document.querySelector('.toast-container');
        const toast = document.createElement('div');
        toast.className = `toast ${type}`;
        
        toast.innerHTML = `
            ${message}
            <button class="toast-close">&times;</button>
            <div class="toast-progress"></div>
        `;
        
        container.appendChild(toast);
        
        // Force reflow
        toast.offsetHeight;
        
        // Show toast
        requestAnimationFrame(() => {
            toast.classList.add('show');
        });
        
        // Setup progress bar
        const progress = toast.querySelector('.toast-progress');
        progress.style.width = '100%';
        progress.style.transition = `width ${duration}ms linear`;
        requestAnimationFrame(() => {
            progress.style.width = '0%';
        });

        // Close button handler
        toast.querySelector('.toast-close').addEventListener('click', () => {
            toast.classList.remove('show');
            setTimeout(() => toast.remove(), 300);
        });

        // Auto remove
        setTimeout(() => {
            toast.classList.remove('show');
            setTimeout(() => toast.remove(), 300);
        }, duration);
    }
}

