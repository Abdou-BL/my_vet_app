export class CommentManager {
    constructor() {
        this.setupStyles();
    }

    setupStyles() {
        const style = document.createElement('style');
        style.textContent = `
            .comment-actions {
                display: flex;
                gap: 10px;
                margin-top: 8px;
            }

            .comment-action-btn {
                background: none;
                border: none;
                color: #2E7D32;
                cursor: pointer;
                font-size: 12px;
                padding: 2px 5px;
                display: flex;
                align-items: center;
                gap: 4px;
            }

            .comment-action-btn:hover {
                text-decoration: underline;
            }

            .comment-likes {
                color: #666;
                font-size: 12px;
            }

            .comment-edit-form {
                display: flex;
                gap: 10px;
                margin-top: 10px;
            }

            .comment-edit-input {
                flex: 1;
                padding: 8px;
                border: 1px solid #2E7D32;
                border-radius: 4px;
            }

            .comment-replies {
                margin-left: 20px;
                margin-top: 10px;
                border-left: 2px solid #e0e0e0;
                padding-left: 10px;
            }

            .reply-form {
                display: flex;
                gap: 10px;
                margin-top: 10px;
            }
        `;
        document.head.appendChild(style);
    }

    getCommentHTML(comment, isReply = false) {
        if (!comment) return '';
        
        const likes = comment.likes || 0;
        const replies = comment.replies || [];
        const text = comment.text || '';
        const timestamp = comment.timestamp || new Date().toISOString();
        const id = comment.id || Date.now().toString();
        
        return `
            <div class="comment" data-comment-id="${id}">
                <div class="comment-header">
                    <span class="comment-author">User</span>
                    <span class="comment-timestamp">${new Date(timestamp).toLocaleDateString()} at ${new Date(timestamp).toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'})}</span>
                </div>
                <p class="comment-text">${text}</p>
                <div class="comment-actions">
                    <button class="comment-action-btn like-comment">
                        <svg width="12" height="12" viewBox="0 0 24 24" fill="currentColor">
                            <path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/>
                        </svg>
                        <span class="likes-count">${likes}</span>
                    </button>
                    ${!isReply ? '<button class="comment-action-btn reply-comment">Reply</button>' : ''}
                    <button class="comment-action-btn edit-comment">Edit</button>
                    <button class="comment-action-btn delete-comment">Delete</button>
                </div>
                ${!isReply ? `
                    <div class="comment-replies">
                        ${replies.map(reply => this.getCommentHTML(reply, true)).join('')}
                    </div>
                ` : ''}
            </div>
        `;
    }

    setupCommentEvents(commentElement, announcement, interactions) {
        if (!commentElement || !announcement || !interactions) {
            console.warn('Missing required parameters in setupCommentEvents');
            return;
        }

        const commentId = commentElement?.dataset?.commentId;
        if (!commentId) {
            console.warn('Comment element missing commentId');
            return;
        }

        // Initialize comments array if it doesn't exist
        if (!interactions.comments) {
            interactions.comments = [];
        }

        let comment = this.findComment(interactions.comments, commentId);
        
        // If comment not found, create a new one
        if (!comment) {
            comment = {
                id: commentId,
                text: commentElement.querySelector('.comment-text')?.textContent || '',
                timestamp: new Date().toISOString(),
                likes: 0,
                replies: []
            };
            interactions.comments.push(comment);
        }

        const likeBtn = commentElement.querySelector('.like-comment');
        const editBtn = commentElement.querySelector('.edit-comment');
        const deleteBtn = commentElement.querySelector('.delete-comment');
        const replyBtn = commentElement.querySelector('.reply-comment');

        if (likeBtn) {
            likeBtn.addEventListener('click', () => {
                comment.likes = (comment.likes || 0) + 1;
                likeBtn.querySelector('.likes-count').textContent = comment.likes;
                this.saveInteractions(announcement, interactions);
            });
        }

        if (editBtn) {
            editBtn.addEventListener('click', () => {
                const textElement = commentElement.querySelector('.comment-text');
                if (!textElement) return;
                
                const currentText = comment.text || '';

                const form = document.createElement('form');
                form.className = 'comment-edit-form';
                form.innerHTML = `
                    <input type="text" class="comment-edit-input" value="${currentText}">
                    <button type="submit" class="comment-submit">Save</button>
                `;

                textElement.replaceWith(form);

                form.addEventListener('submit', (e) => {
                    e.preventDefault();
                    const newText = form.querySelector('.comment-edit-input').value.trim();
                    if (newText) {
                        comment.text = newText;
                        const newTextElement = document.createElement('p');
                        newTextElement.className = 'comment-text';
                        newTextElement.textContent = newText;
                        form.replaceWith(newTextElement);
                        this.saveInteractions(announcement, interactions);
                    }
                });
            });
        }

        if (deleteBtn) {
            deleteBtn.addEventListener('click', () => {
                this.removeComment(interactions.comments || [], comment.id);
                commentElement.remove();
                this.saveInteractions(announcement, interactions);
            });
        }

        if (replyBtn) {
            replyBtn.addEventListener('click', () => {
                const repliesContainer = commentElement.querySelector('.comment-replies');
                if (!repliesContainer) return;
                
                const form = document.createElement('form');
                form.className = 'reply-form';
                form.innerHTML = `
                    <input type="text" class="comment-input" placeholder="Write a reply...">
                    <button type="submit" class="comment-submit">Reply</button>
                `;

                repliesContainer.insertBefore(form, repliesContainer.firstChild);

                form.addEventListener('submit', (e) => {
                    e.preventDefault();
                    const input = form.querySelector('.comment-input');
                    const text = input.value.trim();
                    
                    if (text) {
                        const reply = {
                            id: Date.now().toString(),
                            text,
                            timestamp: new Date().toISOString(),
                            likes: 0
                        };
                        
                        if (!comment.replies) {
                            comment.replies = [];
                        }
                        
                        comment.replies.unshift(reply);
                        
                        const replyElement = document.createElement('div');
                        replyElement.innerHTML = this.getCommentHTML(reply, true);
                        
                        const replyNode = replyElement.firstChild;
                        form.replaceWith(replyNode);
                        
                        this.setupCommentEvents(replyNode, announcement, interactions);
                        this.saveInteractions(announcement, interactions);
                    }
                });
            });
        }
    }

    findComment(comments, id) {
        if (!Array.isArray(comments) || !id) return null;
        
        for (let comment of comments) {
            if (comment?.id === id) return comment;
            if (Array.isArray(comment?.replies)) {
                const found = this.findComment(comment.replies, id);
                if (found) return found;
            }
        }
        return null;
    }

    removeComment(comments, id) {
        if (!Array.isArray(comments)) return false;
        
        const index = comments.findIndex(c => c.id === id);
        if (index > -1) {
            comments.splice(index, 1);
            return true;
        }
        
        for (let comment of comments) {
            if (Array.isArray(comment.replies) && this.removeComment(comment.replies, id)) {
                return true;
            }
        }
        return false;
    }

    getInteractions(announcement) {
        if (!announcement || !announcement.id) {
            return {likes: 0, comments: []};
        }
        return JSON.parse(localStorage.getItem(`announcement-${announcement.id}-interactions`) || '{"likes": 0, "comments": []}');
    }

    saveInteractions(announcement, interactions) {
        if (!announcement || !announcement.id) return;
        localStorage.setItem(`announcement-${announcement.id}-interactions`, JSON.stringify(interactions));
    }
}