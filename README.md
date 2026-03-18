# Spacious Africa

Africa's premier multi-channel entertainment platform — movies, music, talent, events, merchandise, and more, all under one roof.

---

## Features

- **Movies** — African cinema showcase with trailers and social links
- **Music** — Afrobeats and African music with streaming platform links
- **Artists** — Profiles for actors, musicians, and creatives
- **Events** — Upcoming shows, concerts, and productions
- **Wear** — Merchandise store with order management
- **Adverts** — Ad campaign showcase for brands
- **Gallery** — Behind-the-scenes photos and new project teasers
- **Media** — Coming soon media releases

---

## Tech Stack

| Layer | Technology |
|---|---|
| Backend | Django 6.0 |
| Database | SQLite (dev) |
| Styling | Tailwind CSS (Play CDN) |
| Icons | Font Awesome 6.5 |
| Font | DM Sans (Google Fonts) |
| Media | Django ImageField + Pillow |
| Runtime | Python 3.14 |

---

## Project Structure

```
spaciousafrica/
├── core/           # Homepage, about, contact
├── movies/         # Movie listings and detail pages
├── music/          # Track listings and detail pages
├── artists/        # Artist profiles
├── events/         # Upcoming events
├── wear/           # Merchandise store
├── adverts/        # Ad campaigns
├── media/          # Media releases (coming soon)
├── gallery/        # Gallery and new projects
├── templates/      # All HTML templates
├── static/         # CSS, JS, images
└── spaciousafrica/ # Project settings and URLs
```

---

## Getting Started

### Prerequisites

- Python 3.10+
- pip

### Installation

```bash
# Clone the repo
git clone https://github.com/yourusername/spaciousafrica.git
cd spaciousafrica

# Create and activate virtual environment
python3 -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate

# Install dependencies
pip install django pillow

# Apply migrations
python manage.py migrate

# Create a superuser
python manage.py createsuperuser

# Run the development server
python manage.py runserver
```

Visit `http://127.0.0.1:8000` in your browser.

---

## Admin Panel

Access the admin at `http://127.0.0.1:8000/admin/` to manage:

- Movies, tracks, artists, events
- Products, orders, adverts
- Gallery items and new projects
- Contact messages

---

## Environment

For production, make sure to:

- Set `DEBUG = False`
- Set a strong `SECRET_KEY`
- Configure `ALLOWED_HOSTS`
- Use a production-grade database (PostgreSQL recommended)
- Run `python manage.py collectstatic`

---

## License

All rights reserved. &copy; Spacious Africa.
