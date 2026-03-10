CREATE DATABASE QuanLyShop;
GO

USE QuanLyShop;
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


-- VIEW NGUOI DUNG
CREATE VIEW v_NguoiDung AS
SELECT MaNguoiDung, Ten, DienThoai, VaiTro
FROM NguoiDung;
GO

-- VIEW DANH MUC + SAN PHAM
CREATE VIEW v_DanhMuc AS
SELECT 
    d.MaDanhMuc,
    d.TenDanhMuc,
    s.MaSanPham,
    s.TenSanPham,
    s.Gia
FROM DanhMuc d
JOIN SanPham s
ON d.MaDanhMuc = s.MaDanhMuc;
GO

-- VIEW SAN PHAM
CREATE VIEW v_SanPham AS
SELECT 
    sp.MaSanPham,
    sp.TenSanPham,
    sp.Gia,
    dm.TenDanhMuc
FROM SanPham sp
JOIN DanhMuc dm 
ON sp.MaDanhMuc = dm.MaDanhMuc;
GO

-- VIEW CHI TIET DON HANG
CREATE VIEW v_ChiTietDonHang AS
SELECT
    dh.MaDonHang,
    nd.Ten AS TenKhachHang,
    sp.TenSanPham,
    ct.SoLuong,
    ct.Gia
FROM DonHang dh
JOIN NguoiDung nd ON dh.MaNguoiDung = nd.MaNguoiDung
JOIN ChiTietDonHang ct ON dh.MaDonHang = ct.MaDonHang
JOIN SanPham sp ON ct.MaSanPham = sp.MaSanPham;
GO

-- VIEW TONG TIEN DON HANG
CREATE VIEW v_TongTienDonHang AS
SELECT
    MaDonHang,
    SUM(SoLuong * Gia) AS TongTien
FROM ChiTietDonHang
GROUP BY MaDonHang;
GO

SELECT * FROM v_NguoiDung
SELECT * FROM v_DanhMuc
SELECT * FROM v_SanPham
SELECT * FROM v_ChiTietDonHang
SELECT * FROM v_TongTienDonHang