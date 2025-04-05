import { CommentManager } from './commentManager.js';

export class AnnouncementDetailView {
    constructor() {
        this.setupStyles();
        this.commentManager = new CommentManager();
    }

    setupStyles() {
        // Add any necessary dynamic styles
        const style = document.createElement('style');
        style.textContent = `
            .announcement-detail-overlay {
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: rgba(0,0,0,0.9);
                display: flex;
                align-items: center;
                justify-content: center;
                z-index: 2000;
            }

            .announcement-detail {
                position: relative;
                max-height: 90vh;
                overflow: hidden;
                display: flex;
                flex-direction: column;
            }

            .announcement-detail-scrollable {
                overflow-y: auto;
                max-height: calc(90vh - 50px);
                padding-right: 15px;
            }

            .announcement-detail-close {
                position: absolute;
                top: 15px;
                right: 15px;
                background: rgba(0,0,0,0.5);
                color: white;
                border: none;
                width: 40px;
                height: 40px;
                border-radius: 50%;
                font-size: 24px;
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
                z-index: 10;
                transition: background 0.3s;
            }

            .announcement-detail-close:hover {
                background: rgba(0,0,0,0.8);
            }

            .image-container {
                position: relative;
            }

            .zoom-btn {
                position: absolute;
                top: 10px;
                right: 10px;
                background: rgba(128, 128, 128, 0.7);
                border: none;
                cursor: pointer;
                padding: 8px;
                border-radius: 50%;
                transition: background 0.3s;
            }

            .zoom-btn:hover {
                background: rgba(128, 128, 128, 0.9);
            }

            .zoom-btn svg {
                display: block;
                color: white;
            }

            .zoomed-image-overlay {
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: rgba(0,0,0,0.9);
                display: none;
                justify-content: center;
                align-items: center;
                z-index: 2001;
            }

            .zoomed-image-overlay.active {
                display: flex;
            }

            .zoom-close {
                position: absolute;
                top: 15px;
                right: 15px;
                background: rgba(0,0,0,0.5);
                color: white;
                border: none;
                width: 40px;
                height: 40px;
                border-radius: 50%;
                font-size: 24px;
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
                transition: background 0.3s;
            }

            .zoom-close:hover {
                background: rgba(0,0,0,0.8);
            }

            .zoomed-image {
                max-width: 80%;
                max-height: 80%;
            }

            .announcement-interactions {
                margin-top: 10px;
            }

            .interaction-btn {
                background: none;
                border: none;
                cursor: pointer;
                margin-right: 10px;
            }

            .interaction-btn svg {
                width: 24px;
                height: 24px;
            }

            .likes-count, .comments-count {
                font-size: 16px;
                margin-left: 5px;
            }

            .liked {
                color: #007bff;
            }

            .comments-section {
                margin-top: 20px;
            }

            .comment-form {
                display: flex;
                margin-bottom: 10px;
            }

            .comment-input {
                padding: 10px;
                border: 1px solid #ccc;
                border-radius: 5px;
                width: 80%;
            }

            .comment-submit {
                background: #007bff;
                color: #fff;
                border: none;
                padding: 10px 20px;
                border-radius: 5px;
                cursor: pointer;
            }

            .comments-list {
                padding: 0;
                list-style: none;
            }

            .comment {
                background: #f0f0f0;
                padding: 10px;
                border-bottom: 1px solid #ccc;
            }

            .comment-header {
                display: flex;
                justify-content: space-between;
                margin-bottom: 5px;
            }

            .comment-author {
                font-weight: bold;
            }

            .comment-timestamp {
                font-size: 14px;
                color: #666;
            }

            .comment-text {
                margin-bottom: 10px;
            }
        `;
        document.head.appendChild(style);
    }

    show(announcement) {
        if (!announcement) {
            console.warn('No announcement provided to show');
            return;
        }

        let interactions = this.getInteractions(announcement);
        
        const overlay = document.createElement('div');
        overlay.className = 'announcement-detail-overlay';
        
        const detailContent = `
            <div class="announcement-detail">
                <button class="announcement-detail-close">&times;</button>
                <div class="image-container">
                    <button class="zoom-btn">
                        <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor">
                            <path d="M8 3a5 5 0 1 0 0 10A5 5 0 0 0 8 3zm0 8a3 3 0 1 1 0-6 3 3 0 0 1 0 6z"/>
                            <path d="M14.7 13.3l-3-3a6 6 0 1 0-1.4 1.4l3 3a1 1 0 0 0 1.4-1.4z"/>
                        </svg>
                    </button>
                    <img src="${announcement.image}" class="announcement-detail-image">
                </div>
                <div class="announcement-detail-scrollable">
                    <div class="announcement-detail-content">
                        <div class="announcement-detail-header">
                            <h2>${announcement.title}</h2>
                            <span class="announcement-timestamp">${new Date(announcement.timestamp).toLocaleDateString()} at ${new Date(announcement.timestamp).toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'})}</span>
                        </div>
                        <p>${announcement.description}</p>
                        
                        <div class="announcement-interactions">
                            <button class="interaction-btn like-btn ${interactions.likes > 0 ? 'liked' : ''}">
                                <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
                                    <path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/>
                                </svg>
                                <span class="likes-count">${interactions.likes}</span>
                            </button>
                            <button class="interaction-btn">
                                <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
                                    <path d="M21 15a2 2 0 0 1-2 2h-2v3l-4-3H7a2 2 0 0 1-2-2V7a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2v8z"/>
                                </svg>
                                <span class="comments-count">${interactions.comments.length}</span>
                            </button>
                        </div>
                        
                        <div class="comments-section">
                            <form class="comment-form">
                                <input type="text" class="comment-input" placeholder="Write a comment...">
                                <button type="submit" class="comment-submit">Post</button>
                            </form>
                            
                            <div class="comments-list">
                                ${interactions.comments.map(comment => 
                                    this.commentManager.getCommentHTML(comment)
                                ).join('')}
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="zoomed-image-overlay">
                <button class="zoom-close">&times;</button>
                <img src="${announcement.image}" class="zoomed-image">
            </div>
        `;

        overlay.innerHTML = detailContent;
        document.body.appendChild(overlay);

        // Set up comment events for existing comments
        overlay.querySelectorAll('.comment').forEach(commentElement => {
            this.commentManager.setupCommentEvents(commentElement, announcement, interactions);
        });

        // Add zoom functionality
        const zoomBtn = overlay.querySelector('.zoom-btn');
        const zoomOverlay = overlay.querySelector('.zoomed-image-overlay');
        const zoomClose = overlay.querySelector('.zoom-close');

        zoomBtn.addEventListener('click', () => {
            zoomOverlay.classList.add('active');
        });

        zoomClose.addEventListener('click', () => {
            zoomOverlay.classList.remove('active');
        });

        zoomOverlay.addEventListener('click', (e) => {
            if (e.target === zoomOverlay) {
                zoomOverlay.classList.remove('active');
            }
        });

        // Add event listeners
        const closeBtn = overlay.querySelector('.announcement-detail-close');
        const likeBtn = overlay.querySelector('.like-btn');

        closeBtn.addEventListener('click', () => {
            overlay.remove();
        });

        likeBtn.addEventListener('click', () => {
            interactions.likes = likeBtn.classList.contains('liked') ? interactions.likes - 1 : interactions.likes + 1;
            likeBtn.classList.toggle('liked');
            overlay.querySelector('.likes-count').textContent = interactions.likes;
            localStorage.setItem(`announcement-${announcement.id}-interactions`, JSON.stringify(interactions));
        });

        // Update comment form submission
        const commentForm = overlay.querySelector('.comment-form');
        commentForm.addEventListener('submit', (e) => {
            e.preventDefault();
            const input = commentForm.querySelector('.comment-input');
            const text = input.value.trim();
            
            if (text) {
                const comment = {
                    id: Date.now().toString(),
                    text,
                    timestamp: new Date().toISOString(),
                    likes: 0,
                    replies: []
                };
                
                interactions.comments.unshift(comment);
                localStorage.setItem(`announcement-${announcement.id}-interactions`, JSON.stringify(interactions));
                
                const commentElement = document.createElement('div');
                commentElement.innerHTML = this.commentManager.getCommentHTML(comment);
                
                const commentNode = commentElement.firstChild;
                overlay.querySelector('.comments-list').prepend(commentNode);
                this.commentManager.setupCommentEvents(commentNode, announcement, interactions);
                
                input.value = '';
            }
        });
    }

    getInteractions(announcement) {
        if (!announcement?.id) return { likes: 0, comments: [] };
        
        try {
            const stored = localStorage.getItem(`announcement-${announcement.id}-interactions`);
            if (!stored) return { likes: 0, comments: [] };
            
            const parsed = JSON.parse(stored);
            return {
                likes: parsed.likes || 0,
                comments: Array.isArray(parsed.comments) ? parsed.comments : []
            };
        } catch (e) {
            console.error('Error loading interactions:', e);
            return { likes: 0, comments: [] };
        }
    }
}