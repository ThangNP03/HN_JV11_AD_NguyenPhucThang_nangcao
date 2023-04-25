create database QLBH_NguyePhucThanng;
use QLBH_NguyePhucThanng;
-- ============================ Custommer ===============================
create table Custommer (
	cID int primary key unique not null ,
    cName varchar(50),
    cAge tinyint  
);
insert into Custommer values 
(1,"Minh Quan ", 10) ,
(2,"Ngoc Oanh ", 20),
(3,"Hong Ha  ", 50);

-- ============================ Order ===============================
create table Orders (
	oID int primary key unique not null ,
    cID int ,
    foreign key (cID) references Custommer (cID),
    oDate datetime ,
    oTotalPrice float
);
insert into Orders values 

(1, 1, "2006/03/21", null),
(2, 2, "2006/03/23", null),
(3, 1, "2006/03/16", null);
-- ============================ Product ===============================
create table Product(
	pID int primary key unique not null ,
    pName varchar(255),
    pPrice float
);
insert into Product values 
(1, "May Giat", 3),
(2, "Tu Lanh ", 5),
(3, "Dieu Hoa", 7),
(4, "Quat", 1),
(5, "Bep Dien", 2);
-- ============================ OrderDetail ===============================
create table OrderDetail(
	oID int ,
    foreign key (oID) references Orders(oID),
    pID int,
    foreign key (pID) references Product(pID),
    odQTY int 
);
insert into OrderDetail values 
(1,1,3),
(1,3,7),
(1,4,2),
(2,1,1),
(3,1,8),
(2,5,4),
(2,3,3);

-- 2. Hiển thị các thông tin gồm oID, oDate, oPrice của tất cả các hóa đơntrong bảng Order, danh sách phải sắp xếp theo thứ tự ngày tháng, hóa đơn mới hơn nằm trên như hình sau:
select orders.oId, orders.oDate, orders.oTotalPrice from orders order by orders.oDate Desc;
-- 3. Hiển thị tên và giá của các sản phẩm có giá cao nhất
select pName , pPrice from Product  where pPrice = (select max(pPrice) from  Product);

-- 4. Hiển thị danh sách các khách hàng đã mua hàng, và danh sách sản phẩm được mua bởi các khách 
 select c.cName , p.pName from Custommer c join OrderDetail od on c.cID  = od.oID
 join Product p  on od.pID = p.pID
 join Orders o on od.oID = o.oId;
 -- 5.Hiển thị tên những khách hàng không mua bất kỳ một sản phẩm nào như sau: 
select cName from custommer where cID not in (select cID from Orders );
 -- 6. Hiển thị chi tiết của từng hóa đơn như sau
SELECT o.oID, o.oDate, od.odQTY, p.pName, p.pPrice
FROM Orders o
JOIN OrderDetail od ON o.oID = od.oID
JOIN Product p ON od.pID = p.pID;
-- 7. Hiển thị mã hóa đơn, ngày bán và giá tiền của từng hóa đơn (giá một hóa đơn được tính bằng tổng giá bán của từng loại mặt hàng xuất hiện trong hóa đơn. Giá bán của từng loại được tính = odQTY*pPrice)
select o.oID, o.oDate , sum(odQTY*pPrice) as Total 
from Orders o join OrderDetail od on o.oID = od.oID
join Product p ON od.pID = p.pID group by o.oID;
-- 8. Tạo một view tên là Sales để hiển thị tổng doanh thu của siêu thị như sau
CREATE VIEW Sales AS
SELECT SUM(od.odQTY * p.pPrice) AS Sales
FROM OrderDetail od
JOIN Product p ON od.pID = p.pID;
select * from Sales;
-- 9. Xóa tất cả các ràng buộc khóa ngoại, khóa chính của tất cả các bảng
-- xóa khóa ngoại
ALTER TABLE OrderDetail DROP CONSTRAINT orderdetail_ibfk_1;
ALTER TABLE OrderDetail DROP CONSTRAINT orderdetail_ibfk_2;
ALTER TABLE Orders DROP CONSTRAINT orders_ibfk_1;

-- xóa khóa chính
ALTER TABLE Custommer DROP PRIMARY KEY;
ALTER TABLE Product DROP PRIMARY KEY;
ALTER TABLE Orders DROP PRIMARY KEY;

-- 10.Tạo một trigger tên là cusUpdate trên bảng Customer, sao cho khi sửa mã khách (cID) thì mã khách trong bảng Order cũng được sửa theo
create trigger cusUpdate after update on Custommer 
for each row 
	update Orders set cID  = new.cId where cId = old.cID;
    update Custommer
		set cId = 4 where cId = 1
-- Tạo một stored procedure tên là delProduct nhận vào 1 tham số là tên của một sản phẩm, strored procedure này sẽ xóa sản phẩm có tên được truyên vào thông qua tham số, và các thông tin liên quan đến sản phẩm đó ở trong bảng OrderDetail:
DELIMITER // 
create procedure delProduct(in pNameDel varchar(25))
begin
delete from Product where pName = pNameDel;
delete from OrderDetail where pId = (select pId from Product where pName = pNameDel);
end //
DELIMITER ;
call delProduct("Bep Dien");




