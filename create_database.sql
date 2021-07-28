# create database book_shop;
use book_shop;
create table Authors
(
    author    varchar(255),
    author_id serial primary key,

    index author_idx (author)
);

alter table Authors change author author varchar(255) unique;


create table Books_Authors
(
    book_authors_id bigint unsigned not null,
    book_id         serial primary key,
    author_id       bigint unsigned not null,

    foreign key (author_id) references Authors (author_id) on delete restrict,
    foreign key (book_id) references Books (book_id) on delete restrict
);


create table Genres
(
    genre_id serial primary key,
    genre    varchar(50),

    index genre_idx (genre)
);

alter table Genres change genre genre varchar(50) unique;


create table Publishers
(
    publisher_id serial primary key,
    name         varchar(50),
    address      varchar(255) unique,
    phone        bigint unsigned unique,

    index publishers_name_idx (name)
);

create table Providers
(
    provider_id  serial primary key,
    company_name varchar(255),
    address      varchar(255),
    INN          bigint unsigned unique,
    phone        bigint unsigned unique,
    login        varchar(255) unique not null,
    password     varchar(255) unique not null,

    index providers_company_idx (company_name, INN, phone)
);

create table Providers_List
(
    provider_list_id serial primary key,
    provider_id      bigint unsigned not null,
    book_id          bigint unsigned not null,
    price            decimal(10, 2) unsigned,
    quantity         int unsigned,

    foreign key (provider_id) references Providers (provider_id) on delete restrict,
    foreign key (book_id) references Books (book_id) on delete restrict
);


create table Books
(
    book_id         serial primary key,
    publisher_id    bigint unsigned not null,
    name            varchar(255),
    publishing_year int,
    genre_id        bigint unsigned not null,

    foreign key (genre_id) references Genres (genre_id) on delete restrict,
    foreign key (publisher_id) references Publishers (publisher_id) on delete restrict,

    index books_name_idx (name)
);

alter table Books add constraint foreign key (genre_id) references Genres(genre_id) on delete cascade;
alter table Books add constraint foreign key (publisher_id) references  Publishers(publisher_id) on delete cascade;

create table Storage
(
    store_id serial primary key,
    book_id  bigint unsigned not null,
    price    decimal(10, 2) unsigned,
    quantity int unsigned    not null,

    foreign key (book_id) references Books (book_id) on delete restrict
);


create table Customers
(
    customer_id serial primary key,
    FIO         varchar(255),
    address     varchar(255),
    phone       bigint unsigned unique,
    login       varchar(255) unique not null,
    password    varchar(255)        not null,

    index customers_FIO_phone_idx (FIO, phone)
);



create table Purchases
(
    purchase_id   serial primary key,
    customer_id   bigint unsigned not null,
    staff_id      bigint unsigned    not null,
    purchase_date date,
    price         decimal(10, 2) unsigned,

    foreign key (customer_id) references Customers (customer_id) on delete restrict,
    foreign key (staff_id) references Staff(staff_id) on delete restrict

);


create table Purchases_Books
(
    purchase_book_id serial primary key,
    purchase_id      bigint unsigned not null,
    book_id          bigint unsigned not null,
    book_name        varchar(255),
    price            decimal(10, 2) unsigned,
    quantity         int unsigned    not null,

    foreign key (purchase_id) references Purchases (purchase_id) on delete cascade,
    foreign key (book_id) references Books (book_id) on delete cascade
);

create table Staff_Positions
(
    position_id serial primary key,
    position    varchar(50),
    salary      decimal(10, 2) unsigned not null,

    index staff_positions_position (position)
);


create table Staff
(
    staff_id        serial primary key,
    FIO             varchar(255),
    birthday        date,
    address         varchar(255),
    position_id     bigint unsigned    not null,
    employment_date datetime default now(),
    bonus           decimal(2, 1) unsigned,
    login           varchar(50) unique not null,
    password        varchar(50)        not null,

    foreign key (position_id) references Staff_Positions (position_id) on delete restrict,

    index staff_FIO_idx (FIO)
);



create table Orders
(
    order_id    serial primary key,
    book_id     bigint unsigned not null,
    book_name   varchar(50),
    provider_id bigint unsigned not null,
    staff_id    bigint unsigned not null,
    quantity    int unsigned    not null,

    foreign key (book_id) references Books (book_id) on delete cascade,
    foreign key (provider_id) references Providers (provider_id) on delete cascade,
    foreign key (staff_id) references Staff(staff_id) on delete cascade
)
