-- artists
CREATE TABLE IF NOT EXISTS artists (
    artist_id SERIAL PRIMARY KEY,
    name VARCHAR(120)
);

-- albums
CREATE TABLE IF NOT EXISTS albums (
    album_id SERIAL PRIMARY KEY,
    title VARCHAR(160) NOT NULL,
    artist_id INTEGER NOT NULL REFERENCES artists(artist_id)
        ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- genres
CREATE TABLE IF NOT EXISTS genres (
    genre_id SERIAL PRIMARY KEY,
    name VARCHAR(120)
);

-- media_types
CREATE TABLE IF NOT EXISTS media_types (
    media_type_id SERIAL PRIMARY KEY,
    name VARCHAR(120)
);

-- tracks
CREATE TABLE IF NOT EXISTS tracks (
    track_id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    album_id INTEGER REFERENCES albums(album_id)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    media_type_id INTEGER NOT NULL REFERENCES media_types(media_type_id)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    genre_id INTEGER REFERENCES genres(genre_id)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    composer VARCHAR(220),
    milliseconds INTEGER NOT NULL,
    bytes INTEGER,
    unit_price NUMERIC(10,2) NOT NULL
);

-- employees
CREATE TABLE IF NOT EXISTS employees (
    employee_id SERIAL PRIMARY KEY,
    last_name VARCHAR(20) NOT NULL,
    first_name VARCHAR(20) NOT NULL,
    title VARCHAR(30),
    reports_to INTEGER REFERENCES employees(employee_id)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    birth_date TIMESTAMP,
    hire_date TIMESTAMP,
    address VARCHAR(70),
    city VARCHAR(40),
    state VARCHAR(40),
    country VARCHAR(40),
    postal_code VARCHAR(10),
    phone VARCHAR(24),
    fax VARCHAR(24),
    email VARCHAR(60)
);

-- customers
CREATE TABLE IF NOT EXISTS customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    company VARCHAR(80),
    address VARCHAR(70),
    city VARCHAR(40),
    state VARCHAR(40),
    country VARCHAR(40),
    postal_code VARCHAR(10),
    phone VARCHAR(24),
    fax VARCHAR(24),
    email VARCHAR(60) NOT NULL,
    support_rep_id INTEGER REFERENCES employees(employee_id)
        ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- invoices
CREATE TABLE IF NOT EXISTS invoices (
    invoice_id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL REFERENCES customers(customer_id)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    invoice_date TIMESTAMP NOT NULL,
    billing_address VARCHAR(70),
    billing_city VARCHAR(40),
    billing_state VARCHAR(40),
    billing_country VARCHAR(40),
    billing_postal_code VARCHAR(10),
    total NUMERIC(10,2) NOT NULL
);

-- invoice_items
CREATE TABLE IF NOT EXISTS invoice_items (
    invoice_line_id SERIAL PRIMARY KEY,
    invoice_id INTEGER NOT NULL REFERENCES invoices(invoice_id)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    track_id INTEGER NOT NULL REFERENCES tracks(track_id)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    unit_price NUMERIC(10,2) NOT NULL,
    quantity INTEGER NOT NULL
);

-- playlists
CREATE TABLE IF NOT EXISTS playlists (
    playlist_id SERIAL PRIMARY KEY,
    name VARCHAR(120)
);

-- playlist_track
CREATE TABLE IF NOT EXISTS playlist_track (
    playlist_id INTEGER NOT NULL REFERENCES playlists(playlist_id)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    track_id INTEGER NOT NULL REFERENCES tracks(track_id)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    PRIMARY KEY (playlist_id, track_id)
);