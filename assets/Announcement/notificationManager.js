export class NotificationManager {
    constructor() {
        this.notifications = this.loadNotifications();
    }

    loadNotifications() {
        return JSON.parse(localStorage.getItem('notifications') || '[]');
    }

    saveNotifications() {
        localStorage.setItem('notifications', JSON.stringify(this.notifications));
    }

    addNotification(type, message) {
        const notification = {
            id: Date.now(),
            type,
            message,
            timestamp: new Date().toISOString(),
            read: false
        };
        
        this.notifications.unshift(notification);
        this.saveNotifications();
        this.updateBadge();
        return notification;
    }

    markAsRead(id) {
        const notification = this.notifications.find(n => n.id === id);
        if (notification) {
            notification.read = true;
            this.saveNotifications();
            this.updateBadge();
        }
    }

    markAllAsRead() {
        this.notifications.forEach(n => n.read = true);
        this.saveNotifications();
        this.updateBadge();
    }

    deleteNotification(id) {
        this.notifications = this.notifications.filter(n => n.id !== id);
        this.saveNotifications();
        this.updateBadge();
    }

    clearAll() {
        this.notifications = [];
        this.saveNotifications();
        this.updateBadge();
    }

    getUnreadCount() {
        return this.notifications.filter(n => !n.read).length;
    }

    updateBadge() {
        const badge = document.querySelector('.notification-badge');
        if (badge) {
            const count = this.getUnreadCount();
            badge.textContent = count;
            badge.style.display = count > 0 ? 'flex' : 'none';
        }
    }

    showNotifications() {
        const modalOverlay = document.createElement('div');
        modalOverlay.className = 'category-modal-overlay active';
        
        const notificationsList = this.notifications.map(notification => {
            const date = new Date(notification.timestamp);
            const formattedDate = `${date.toLocaleDateString()} at ${date.toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'})}`;
            
            return `
                <div class="notification-item ${notification.read ? 'read' : 'unread'}" data-id="${notification.id}">
                    <div class="notification-content">
                        <p class="notification-text">${notification.message}</p>
                        <span class="notification-timestamp">${formattedDate}</span>
                    </div>
                    <button class="notification-delete">&times;</button>
                </div>
            `;
        }).join('');
        
        modalOverlay.innerHTML = `
            <div class="category-modal">
                <div class="category-modal-header">
                    <h2 class="category-title">Notifications</h2>
                    <button class="category-modal-close">&times;</button>
                </div>
                <div class="notifications-list">
                    ${notificationsList}
                </div>
                <div class="notification-footer">
                    <button class="mark-all-read">Mark all as read</button>
                    <button class="clear-all">Clear all</button>
                </div>
            </div>
        `;

        document.body.appendChild(modalOverlay);

        // Event handlers
        modalOverlay.querySelector('.category-modal-close').addEventListener('click', () => {
            modalOverlay.remove();
        });

        modalOverlay.querySelector('.mark-all-read').addEventListener('click', () => {
            this.markAllAsRead();
            modalOverlay.querySelectorAll('.notification-item').forEach(item => {
                item.classList.add('read');
                item.classList.remove('unread');
            });
        });

        modalOverlay.querySelector('.clear-all').addEventListener('click', () => {
            this.clearAll();
            modalOverlay.remove();
        });

        modalOverlay.addEventListener('click', (e) => {
            const deleteBtn = e.target.closest('.notification-delete');
            if (deleteBtn) {
                const item = deleteBtn.closest('.notification-item');
                const id = Number(item.dataset.id);
                this.deleteNotification(id);
                item.remove();
                return;
            }

            const notificationItem = e.target.closest('.notification-item');
            if (notificationItem && !notificationItem.classList.contains('read')) {
                const id = Number(notificationItem.dataset.id);
                this.markAsRead(id);
                notificationItem.classList.add('read');
                notificationItem.classList.remove('unread');
            }
        });
    }
}