export class HistoryManager {
    constructor() {
        this.history = JSON.parse(localStorage.getItem('activity-history') || '[]');
        this.setupHistoryDeletion();
    }

    addActivity(type, details) {
        const activity = {
            type,
            details,
            timestamp: new Date().toISOString(),
            id: Date.now()
        };
        
        this.history.unshift(activity);
        if (this.history.length > 100) this.history.pop();
        this.saveHistory();
        
        return activity;
    }
    
    saveHistory() {
        localStorage.setItem('activity-history', JSON.stringify(this.history));
    }
    
    getHistory() {
        return this.history;
    }
    
    getFormattedActivityText(activity) {
        switch(activity.type) {
            case 'view':
                return `Viewed announcement "${activity.details.title}"`;
            case 'comment':
                return `Commented on "${activity.details.announcementTitle}"`;
            case 'share':
                return `Shared announcement "${activity.details.title}"`;
            case 'like':
                return `Liked announcement "${activity.details.title}"`;
            default:
                return 'Unknown activity';
        }
    }

    deleteActivity(id) {
        this.history = this.history.filter(activity => activity.id !== id);
        this.saveHistory();
    }

    clearHistory() {
        this.history = [];
        this.saveHistory();
    }

    setupHistoryDeletion() {
        document.addEventListener('click', (e) => {
            const deleteBtn = e.target.closest('.delete-history-btn');
            if (!deleteBtn) return;
            
            e.stopPropagation(); // Prevent history item click
            const historyItem = deleteBtn.closest('.history-item');
            const id = Number(historyItem.dataset.activityId);
            
            // Remove from DOM
            historyItem.remove();
            
            // Remove from history
            this.deleteActivity(id);
        });
    }

    getHistoryItemHTML(activity) {
        const date = new Date(activity.timestamp);
        const formattedDate = `${date.toLocaleDateString()} at ${date.toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'})}`;
        const actionText = this.getFormattedActivityText(activity);
        
        return `
            <div class="history-item" data-activity-id="${activity.id}" data-type="${activity.type}">
                <div class="history-content">
                    <p class="history-text">${actionText}</p>
                    <span class="history-timestamp">${formattedDate}</span>
                </div>
                <button class="delete-history-btn" title="Delete history item">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                        <path d="M6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12zM19 4h-3.5l-1-1h-5l-1 1H5v2h14V4z"/>
                    </svg>
                </button>
            </div>
        `;
    }
}