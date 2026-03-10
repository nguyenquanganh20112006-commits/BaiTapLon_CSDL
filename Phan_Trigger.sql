CREATE DATABASE QuanLyShop;
GO

USE QLSV;
GO

CREATE TABLE NguoiDung (
    MaNguoiDung INT PRIMARY KEY,
    Ten NVARCHAR(100) NOT NULL,
    DienThoai VARCHAR(15),
    VaiTro NVARCHAR(20)
);

CREATE TABLE DanhMuc (
    MaDanhMuc INT PRIMARY KEY,
    TenDanhMuc NVARCHAR(100) NOT NULL
);

CREATE TABLE SanPham (
    MaSanPham INT PRIMARY KEY,
    TenSanPham NVARCHAR(200) NOT NULL,
    Gia DECIMAL(18,2) NOT NULL,
    SoLuongTon INT NOT NULL,
    MaDanhMuc INT,
    MaNguoiBan INT,
    FOREIGN KEY (MaDanhMuc) REFERENCES DanhMuc(MaDanhMuc),
    FOREIGN KEY (MaNguoiBan) REFERENCES NguoiDung(MaNguoiDung)
);

CREATE TABLE DonHang (
    MaDonHang INT PRIMARY KEY,
    MaNguoiDung INT,
    NgayDat DATETIME DEFAULT GETDATE(),
    TongTien DECIMAL(18,2),
    TrangThai NVARCHAR(50),
    FOREIGN KEY (MaNguoiDung) REFERENCES NguoiDung(MaNguoiDung)
);

CREATE TABLE ChiTietDonHang (
    MaDonHang INT,
    MaSanPham INT,
    SoLuong INT NOT NULL,
    Gia DECIMAL(18,2) NOT NULL,
    PRIMARY KEY (MaDonHang, MaSanPham),
    FOREIGN KEY (MaDonHang) REFERENCES DonHang(MaDonHang),
    FOREIGN KEY (MaSanPham) REFERENCES SanPham(MaSanPham)
);

INSERT INTO NguoiDung VALUES
(1,N'Nguyen Van A','0900000001',N'KhachHang'),
(2,N'Tran Van B','0900000002',N'NguoiBan');

INSERT INTO DanhMuc VALUES
(1,N'Ao'),
(2,N'Quan');

INSERT INTO SanPham VALUES
(1,N'Ao thun',200000,50,1,2),
(2,N'Quan jean',400000,30,2,2);

INSERT INTO DonHang VALUES
(1,1,GETDATE(),600000,N'DaDat');

INSERT INTO ChiTietDonHang VALUES
(1,1,1,200000),
(1,2,1,400000);






GO
CREATE TRIGGER trg_TruTonKho
ON ChiTietDonHang
AFTER INSERT
AS
BEGIN
    UPDATE SanPham
    SET SoLuongTon = SoLuongTon - i.SoLuong
    FROM SanPham sp
    JOIN inserted i ON sp.MaSanPham = i.MaSanPham
END

GO
CREATE TRIGGER trg_KiemTraTonKho
ON ChiTietDonHang
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS(
        SELECT *
        FROM inserted i
        JOIN SanPham sp ON i.MaSanPham = sp.MaSanPham
        WHERE sp.SoLuongTon < i.SoLuong
    )
    BEGIN
        PRINT N'Không đủ số lượng sản phẩm trong kho'
    END
    ELSE
    BEGIN
        INSERT INTO ChiTietDonHang
        SELECT * FROM inserted
    END
END

GO
CREATE TRIGGER trg_KhongChoXoaSanPham
ON SanPham
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS(
        SELECT *
        FROM ChiTietDonHang ct
        JOIN deleted d ON ct.MaSanPham = d.MaSanPham
    )
    BEGIN
        PRINT N'Không thể xóa sản phẩm đã có trong đơn hàng'
    END
    ELSE
    BEGIN
        DELETE FROM SanPham
        WHERE MaSanPham IN (SELECT MaSanPham FROM deleted)
    END
END

INSERT INTO ChiTietDonHang VALUES
(1,1,2,200000)
SELECT * FROM SanPham
INSERT INTO ChiTietDonHang VALUES
(1,2,1,400000)
SELECT * FROM SanPham