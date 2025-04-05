import { config } from 'config';
import { AnnouncementDetailView } from './announcementDetail.js';
import { HistoryManager } from './historyManager.js';
import { NotificationManager } from './notificationManager.js';
import { ToastNotification } from './toastNotification.js';

class StreamingApp {
    constructor() {
        this.announcements = JSON.parse(localStorage.getItem('announcements') || '[]');
        this.currentHeroSlide = 0;
        this.currentCategoryPosition = 0;
        this.historyManager = new HistoryManager();
        this.notificationManager = new NotificationManager();
        this.toastNotification = new ToastNotification();
        
        this.updateHeroSlides();
        this.initializeHeroSlider();
        this.initializeCategories();
        this.startAutoPlay();
        this.startCategoryScroll();
        this.initializeShareModal();
        this.initializeCategoryModal();
        this.initializeCategoryNavigation();
        this.detailView = new AnnouncementDetailView();
        this.initializeSettingsMenu();
    }

    updateHeroSlides() {
        // Update the existing method to include delete buttons for hero slides
        const container = document.querySelector('.slider-container');
        container.innerHTML = '';
        
        config.heroSlides = this.announcements
            .slice(0, 5)
            .map(announcement => ({
                id: announcement.id,
                title: announcement.title,
                description: announcement.description,
                background: `url(${announcement.image}) center/cover no-repeat`
            }));

        config.heroSlides.forEach(slide => {
            const slideEl = document.createElement('div');
            slideEl.className = 'hero-slide';
            slideEl.style.background = slide.background;
            
            // Add delete button
            const deleteBtn = document.createElement('button');
            deleteBtn.className = 'delete-btn';
            deleteBtn.innerHTML = '&times;';
            deleteBtn.addEventListener('click', (e) => {
                e.stopPropagation();
                this.deleteAnnouncement(slide.id);
            });
            
            const content = document.createElement('div');
            content.className = 'slide-content';
            content.innerHTML = `
                <h2>${slide.title}</h2>
                <p>${slide.description}</p>
            `;
            
            slideEl.appendChild(deleteBtn);
            slideEl.appendChild(content);
            container.appendChild(slideEl);
        });
    }

    initializeHeroSlider() {
        // Remove existing initialization since it's now part of updateHeroSlides
        document.querySelector('.hero-prev').addEventListener('click', () => this.prevSlide());
        document.querySelector('.hero-next').addEventListener('click', () => this.nextSlide());
    }

    initializeCategories() {
        const container = document.querySelector('.categories-container');
        
        config.categories.forEach(category => {
            const card = document.createElement('div');
            card.className = 'category-card';
            card.style.background = category.background;
            card.dataset.categoryId = category.id;
            
            const title = document.createElement('div');
            title.className = 'category-title';
            title.textContent = category.title;
            
            card.appendChild(title);
            container.appendChild(card);
        });
    }

    nextSlide() {
        // Update the slider position immediately when using navigation
        this.currentHeroSlide = (this.currentHeroSlide + 1) % config.heroSlides.length;
        this.updateSliderPosition();
    }

    prevSlide() {
        // Update the slider position immediately when using navigation
        this.currentHeroSlide = (this.currentHeroSlide - 1 + config.heroSlides.length) % config.heroSlides.length;
        this.updateSliderPosition();
    }

    updateSliderPosition() {
        const container = document.querySelector('.slider-container');
        container.style.transform = `translateX(-${this.currentHeroSlide * 100}%)`;
    }

    scrollCategories() {
        const container = document.querySelector('.categories-container');
        const cards = document.querySelectorAll('.category-card');
        
        this.currentCategoryPosition = (this.currentCategoryPosition + 1) % cards.length;
        
        if (this.currentCategoryPosition === 0) {
            container.style.transition = 'none';
            container.style.transform = 'translateX(0)';
            // Force reflow
            container.offsetHeight;
            container.style.transition = 'transform 0.5s ease';
        } else {
            container.style.transform = `translateX(-${this.currentCategoryPosition * 220}px)`;
        }
    }

    startAutoPlay() {
        setInterval(() => this.nextSlide(), config.autoPlayDelay);
    }

    startCategoryScroll() {
        setInterval(() => this.scrollCategories(), config.categoryScrollDelay);
    }

    initializeShareModal() {
        const fab = document.querySelector('.fab');
        const modalOverlay = document.querySelector('.modal-overlay');
        const modal = document.querySelector('.modal');
        const closeBtn = document.querySelector('.modal-close');
        const dragHandle = document.querySelector('.drag-handle');
        const shareForm = document.querySelector('.share-form');
        const imageUpload = document.querySelector('.image-upload');
        const fileInput = document.querySelector('#image');
        const imagePreview = document.querySelector('.image-preview');

        let isDragging = false;
        let startY = 0;
        let startTranslateY = 0;
        const maxTranslateY = window.innerHeight * 0.4; // 40% of viewport height

        dragHandle.addEventListener('mousedown', (e) => {
            isDragging = true;
            startY = e.clientY;
            startTranslateY = modal.style.transform ? 
                parseInt(modal.style.transform.replace('translateY(', '').replace('px)', '')) : 0;
            modal.style.transition = 'none';
        });

        window.addEventListener('mousemove', (e) => {
            if (!isDragging) return;
            
            const deltaY = e.clientY - startY;
            const newTranslateY = Math.max(-maxTranslateY, 
                Math.min(maxTranslateY, startTranslateY + deltaY));
            
            modal.style.transform = `translateY(${newTranslateY}px)`;
        });

        window.addEventListener('mouseup', () => {
            if (!isDragging) return;
            isDragging = false;
            modal.style.transition = 'transform 0.3s ease';
        });

        // Open modal
        fab.addEventListener('click', () => {
            modalOverlay.classList.add('active');
        });

        // Close modal
        closeBtn.addEventListener('click', () => {
            modalOverlay.classList.remove('active');
        });

        modalOverlay.addEventListener('click', (e) => {
            if (e.target === modalOverlay) {
                modalOverlay.classList.remove('active');
            }
        });

        // Handle image upload
        imageUpload.addEventListener('click', () => {
            fileInput.click();
        });

        imageUpload.addEventListener('dragover', (e) => {
            e.preventDefault();
            imageUpload.style.borderColor = '#E50914';
        });

        imageUpload.addEventListener('dragleave', () => {
            imageUpload.style.borderColor = '#333';
        });

        imageUpload.addEventListener('drop', (e) => {
            e.preventDefault();
            imageUpload.style.borderColor = '#333';
            const file = e.dataTransfer.files[0];
            if (file && file.type.startsWith('image/')) {
                this.handleImageFile(file, imagePreview);
            }
        });

        fileInput.addEventListener('change', () => {
            const file = fileInput.files[0];
            if (file) {
                this.handleImageFile(file, imagePreview);
            }
        });

        // Add category selection to the form
        const categorySelect = document.createElement('select');
        categorySelect.id = 'category';
        categorySelect.required = true;
        
        const defaultOption = document.createElement('option');
        defaultOption.value = '';
        defaultOption.textContent = 'Select a category';
        defaultOption.disabled = true;
        defaultOption.selected = true;
        categorySelect.appendChild(defaultOption);

        config.categories.forEach(category => {
            const option = document.createElement('option');
            option.value = category.id;
            option.textContent = category.title;
            categorySelect.appendChild(option);
        });

        const categoryGroup = document.createElement('div');
        categoryGroup.className = 'form-group';
        const categoryLabel = document.createElement('label');
        categoryLabel.htmlFor = 'category';
        categoryLabel.textContent = 'Category';
        categoryGroup.appendChild(categoryLabel);
        categoryGroup.appendChild(categorySelect);

        const submitBtn = document.querySelector('.submit-btn');
        submitBtn.parentNode.insertBefore(categoryGroup, submitBtn);

        // Update form submission
        shareForm.addEventListener('submit', (e) => {
            e.preventDefault();
            const titleInput = document.querySelector('#title');
            const descriptionInput = document.querySelector('#description');
            const announcement = {
                id: Date.now(),
                title: titleInput.value,
                description: descriptionInput.value,
                category: document.querySelector('#category').value,
                image: document.querySelector('.image-preview').src,
                timestamp: new Date().toISOString()
            };

            this.announcements.unshift(announcement);
            localStorage.setItem('announcements', JSON.stringify(this.announcements));
            this.updateHeroSlides();
            this.initializeHeroSlider();

            this.historyManager.addActivity('share', {
                title: titleInput.value
            });

            this.toastNotification.show('Announcement shared successfully');
            document.querySelector('.modal-overlay').classList.remove('active');
            shareForm.reset();
            document.querySelector('.image-preview').style.display = 'none';
        });
    }

    handleImageFile(file, imagePreview) {
        const reader = new FileReader();
        reader.onload = (e) => {
            imagePreview.src = e.target.result;
            imagePreview.style.display = 'block';
        };
        reader.readAsDataURL(file);
    }

    initializeCategoryModal() {
        // Create category modal HTML
        const modalHTML = `
            <div class="category-modal-overlay">
                <div class="category-modal">
                    <div class="category-modal-header">
                        <h2 class="category-title"></h2>
                        <button class="category-modal-close" title="Close">&times;</button>
                    </div>
                    <div class="announcements-grid"></div>
                </div>
            </div>
        `;
        document.body.insertAdjacentHTML('beforeend', modalHTML);

        // Add click handlers for category cards
        document.querySelector('.categories-container').addEventListener('click', (e) => {
            const card = e.target.closest('.category-card');
            if (card) {
                const categoryId = card.dataset.categoryId;
                this.showCategoryAnnouncements(categoryId);
            }
        });

        // Close modal handler
        document.querySelector('.category-modal-close').addEventListener('click', () => {
            document.querySelector('.category-modal-overlay').classList.remove('active');
        });
    }

    showCategoryAnnouncements(categoryId) {
        const category = config.categories.find(cat => cat.id === categoryId);
        const modalOverlay = document.querySelector('.category-modal-overlay');
        const modalTitle = modalOverlay.querySelector('.category-title');
        const grid = modalOverlay.querySelector('.announcements-grid');

        modalTitle.textContent = category.title;
        grid.innerHTML = '';

        const categoryAnnouncements = this.announcements.filter(a => a.category === categoryId);
        categoryAnnouncements.forEach(announcement => {
            const card = document.createElement('div');
            card.className = 'announcement-card';
            card.style.backgroundImage = `url(${announcement.image})`;
            
            // Add click handler for detailed view
            card.addEventListener('click', () => this.showAnnouncementDetail(announcement));
            
            card.innerHTML = `
                <button class="delete-btn">&times;</button>
                <div class="announcement-content">
                    <h3>${announcement.title}</h3>
                    <p>${announcement.description}</p>
                </div>
            `;

            card.querySelector('.delete-btn').addEventListener('click', (e) => {
                e.stopPropagation();
                this.deleteAnnouncement(announcement.id);
            });

            grid.appendChild(card);
        });

        modalOverlay.classList.add('active');
    }

    showAnnouncementDetail(announcement) {
        this.historyManager.addActivity('view', {
            announcementId: announcement.id,
            title: announcement.title
        });
        this.detailView.show(announcement);
    }

    initializeCategoryNavigation() {
        const prevBtn = document.querySelector('.category-prev');
        const nextBtn = document.querySelector('.category-next');
        
        prevBtn.addEventListener('click', () => {
            const container = document.querySelector('.categories-container');
            const cards = document.querySelectorAll('.category-card');
            this.currentCategoryPosition = Math.max(0, this.currentCategoryPosition - 1);
            container.style.transform = `translateX(-${this.currentCategoryPosition * 220}px)`;
        });
        
        nextBtn.addEventListener('click', () => {
            const container = document.querySelector('.categories-container');
            const cards = document.querySelectorAll('.category-card');
            const maxPosition = cards.length - Math.floor(container.clientWidth / 220);
            this.currentCategoryPosition = Math.min(maxPosition, this.currentCategoryPosition + 1);
            container.style.transform = `translateX(-${this.currentCategoryPosition * 220}px)`;
        });
    }

    initializeSettingsMenu() {
        const settingsBtn = document.querySelector('.settings-btn');
        const settingsMenu = document.querySelector('.settings-menu');
        
        settingsBtn.addEventListener('click', () => {
            settingsMenu.classList.toggle('active');
        });

        // Close menu when clicking outside
        document.addEventListener('click', (e) => {
            if (!settingsMenu.contains(e.target) && !settingsBtn.contains(e.target)) {
                settingsMenu.classList.remove('active');
            }
        });

        // Handle menu item clicks
        const menuItems = document.querySelectorAll('.menu-item');
        menuItems.forEach(item => {
            item.addEventListener('click', () => {
                const action = item.dataset.action;
                switch(action) {
                    case 'my-announcements':
                        this.showMyAnnouncements();
                        break;
                    case 'history':
                        this.showHistory();
                        break;
                    case 'notifications':
                        this.notificationManager.showNotifications();
                        break;
                }
                settingsMenu.classList.remove('active');
            });
        });
    }

    showMyAnnouncements() {
        const modalOverlay = document.createElement('div');
        modalOverlay.className = 'category-modal-overlay active';
        
        modalOverlay.innerHTML = `
            <div class="category-modal">
                <div class="category-modal-header">
                    <h2 class="category-title">My Announcements</h2>
                    <button class="category-modal-close">&times;</button>
                </div>
                <div class="announcements-grid">
                    ${this.announcements.map(announcement => `
                        <div class="announcement-card" style="background-image: url(${announcement.image})">
                            <button class="delete-btn">&times;</button>
                            <div class="announcement-content">
                                <h3>${announcement.title}</h3>
                                <p>${announcement.description}</p>
                            </div>
                        </div>
                    `).join('')}
                </div>
            </div>
        `;

        document.body.appendChild(modalOverlay);

        // Add event listeners
        modalOverlay.querySelector('.category-modal-close').addEventListener('click', () => {
            modalOverlay.remove();
        });

        modalOverlay.addEventListener('click', (e) => {
            if (e.target === modalOverlay) {
                modalOverlay.remove();
            }
        });

        // Add delete functionality
        modalOverlay.querySelectorAll('.delete-btn').forEach((btn, index) => {
            btn.addEventListener('click', (e) => {
                e.stopPropagation();
                this.deleteAnnouncement(this.announcements[index].id);
                modalOverlay.remove();
            });
        });
    }

    showHistory() {
        const history = this.historyManager.getHistory();
        
        const modalOverlay = document.createElement('div');
        modalOverlay.className = 'category-modal-overlay active';
        
        modalOverlay.innerHTML = `
            <div class="category-modal">
                <div class="category-modal-header">
                    <h2 class="category-title">Activity History</h2>
                    <button class="category-modal-close">&times;</button>
                </div>
                <div class="history-list"></div>
            </div>
        `;
        
        document.body.appendChild(modalOverlay);

        modalOverlay.querySelector('.category-modal-close').addEventListener('click', () => {
            modalOverlay.remove();
        });

        modalOverlay.querySelector('.history-list').innerHTML = history.map(activity => 
            this.historyManager.getHistoryItemHTML(activity)
        ).join('');

        modalOverlay.querySelector('.history-list').addEventListener('click', (e) => {
            const historyItem = e.target.closest('.history-item');
            if (!historyItem) return;

            const activity = history.find(a => a.id === Number(historyItem.dataset.activityId));
            if (!activity) return;

            modalOverlay.remove();
            
            switch(activity.type) {
                case 'view':
                case 'comment':
                case 'like':
                    const announcement = this.announcements.find(a => a.id === activity.details.announcementId);
                    if (announcement) {
                        this.showAnnouncementDetail(announcement);
                    }
                    break;
            }
        });
    }

    deleteAnnouncement(id) {
        // Create and show confirmation modal
        const confirmModal = document.createElement('div');
        confirmModal.className = 'confirm-modal';
        confirmModal.innerHTML = `
            <h3>Delete Announcement</h3>
            <p>Are you sure you want to delete this announcement?</p>
            <div class="confirm-modal-buttons">
                <button class="confirm-delete">Delete</button>
                <button class="cancel-delete">Cancel</button>
            </div>
        `;
        document.body.appendChild(confirmModal);

        // Show modal
        setTimeout(() => confirmModal.classList.add('active'), 10);

        // Handle confirmation
        confirmModal.querySelector('.confirm-delete').addEventListener('click', () => {
            this.announcements = this.announcements.filter(a => a.id !== id);
            localStorage.setItem('announcements', JSON.stringify(this.announcements));
            this.updateHeroSlides();
            this.toastNotification.show('Announcement deleted successfully', 'info');

            // Refresh category view if open
            const categoryModal = document.querySelector('.category-modal-overlay.active');
            if (categoryModal) {
                const categoryId = this.announcements.find(a => a.id === id)?.category;
                if (categoryId) {
                    this.showCategoryAnnouncements(categoryId);
                }
            }
        });

        // Handle cancellation
        confirmModal.querySelector('.cancel-delete').addEventListener('click', () => {
            confirmModal.remove();
        });
    }

}

// Initialize the app when the DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    new StreamingApp();
});