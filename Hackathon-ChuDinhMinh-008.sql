create database if not exists Hackathon_008;
use Hackathon_008;

drop table if exists Reservations;
drop table if exists Rooms;
drop table if exists RoomTypes;
drop table if exists Guests;

-- Tạo bảng Guests
create table Guests (
    guest_id varchar(5) primary key not null,
    full_name varchar(100) not null,
    email varchar(100) not null unique,
    phone varchar(15) not null unique
);

-- Tạo bảng RoomTypes
create table RoomTypes (
    type_id varchar(5) primary key not null,
    type_name varchar(100) not null unique
);

-- Tạo bảng Rooms
create table Rooms (
    room_id varchar(5) primary key not null,
    room_name varchar(100) not null unique,
    type_id varchar(5) not null,
    price_per_night decimal(10, 2) not null,
    capacity int not null,
    foreign key (type_id) references RoomTypes(type_id)
);

-- Tạo bảng Reservations
create table Reservations (
    reservation_id int auto_increment primary key not null,
    guest_id varchar(5) not null,
    room_id varchar(5) not null,
    status varchar(20) not null,
    check_in_date date not null,
    foreign key (guest_id) references Guests(guest_id),
    foreign key (room_id) references Rooms(room_id)
);

insert into Guests (guest_id, full_name, email, phone) values
('G01', 'Lê Văn Tám', 'tam.lv@gmail.com', '0901111111'),
('G02', 'Bùi Thị Lan', 'lan.bt@gmail.com', '0902222222'),
('G03', 'Đỗ Hữu Trọng', 'trong.dh@gmail.com', '0903333333'),
('G04', 'Lý Thanh Hà', 'ha.lt@gmail.com', '0904444444'),
('G05', 'Trương Vĩnh Ký', 'ky.tv@gmail.com', '0905555555');

insert into RoomTypes (type_id, type_name) values
('T01', 'Standard'),
('T02', 'Superior'),
('T03', 'Deluxe'),
('T04', 'Suite');

insert into Rooms (room_id, room_name, type_id, price_per_night, capacity) values
('R01', 'Phòng 101', 'T01', 500000.00, 2),
('R02', 'Phòng 102', 'T01', 500000.00, 2),
('R03', 'Phòng 201', 'T02', 800000.00, 2),
('R04', 'Phòng 301', 'T03', 1200000.00, 3),
('R05', 'Phòng 401', 'T04', 2500000.00, 4);

insert into Reservations (reservation_id, guest_id, room_id, status, check_in_date) values
(1, 'G01', 'R01', 'Booked', '2025-10-01'),
(2, 'G02', 'R03', 'Checked-in', '2025-10-02'),
(3, 'G01', 'R02', 'Checked-in', '2025-10-03'),
(4, 'G04', 'R05', 'Cancelled', '2025-10-04'),
(5, 'G05', 'R01', 'Booked', '2025-10-05');

-- Câu 1
update Rooms 
set 
    capacity = capacity + 2, 
    price_per_night = price_per_night * 1.05 
where room_name = 'Phòng 401';

-- Câu 2
update Guests 
set phone = '0999999999' 
where guest_id = 'G03';

-- Câu 3
delete from Reservations 
where status = 'Cancelled' and check_in_date < '2025-10-03';

-- Câu 4
select room_id, room_name, price_per_night 
from Rooms 
where (price_per_night between 800000 and 2000000) 
  and capacity > 2;

-- Câu 5
select full_name, email 
from Guests 
where full_name like 'Lê%';

-- Câu 6
select reservation_id, guest_id, check_in_date 
from Reservations 
order by check_in_date desc;

-- Câu 7
select room_id, room_name, price_per_night, capacity 
from Rooms 
order by price_per_night desc 
limit 3;

-- Câu 8
select room_name, capacity 
from Rooms 
limit 2 offset 2;

-- Câu 9
select 
    r.reservation_id, 
    g.full_name, 
    rm.room_name, 
    r.check_in_date 
from Reservations r
inner join Guests g on r.guest_id = g.guest_id
inner join Rooms rm on r.room_id = rm.room_id
where r.status = 'Booked';

-- Câu 10
select 
    rt.type_name, 
    rm.room_name 
from RoomTypes rt
left join Rooms rm on rt.type_id = rm.type_id;

-- Câu 11
select 
    status, 
    count(reservation_id) as Total_Reservations 
from Reservations 
group by status;

-- Câu 12
select 
    g.full_name 
from Reservations r
inner join Guests g on r.guest_id = g.guest_id
group by g.guest_id, g.full_name
having count(r.reservation_id) >= 2;

-- Câu 13
select 
    room_id, 
    room_name, 
    price_per_night 
from Rooms 
where price_per_night < (select avg(price_per_night) from Rooms);

-- Câu 14
select distinct 
    g.full_name, 
    g.phone 
from Guests g
inner join Reservations r on g.guest_id = r.guest_id
inner join Rooms rm on r.room_id = rm.room_id
where rm.room_name = 'Phòng 101';