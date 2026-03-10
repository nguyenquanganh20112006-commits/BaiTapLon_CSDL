USE master
GO

IF EXISTS (SELECT * FROM sys.databases WHERE name = 'QuanLyShop')
DROP DATABASE QuanLyShop
GO

CREATE DATABASE QuanLyShop
GO

USE QuanLyShop
GO

CREATE TABLE NguoiDung (
    MaNguoiDung INT PRIMARY KEY,
    Ten NVARCHAR(100) NOT NULL,
    DienThoai VARCHAR(15),
    VaiTro NVARCHAR(20)
)

CREATE TABLE DanhMuc (
    MaDanhMuc INT PRIMARY KEY,
    TenDanhMuc NVARCHAR(100) NOT NULL
)

CREATE TABLE SanPham (
    MaSanPham INT PRIMARY KEY,
    TenSanPham NVARCHAR(200) NOT NULL,
    Gia DECIMAL(18,2) NOT NULL,
    SoLuongTon INT NOT NULL,
    MaDanhMuc INT,
    MaNguoiBan INT,
    FOREIGN KEY (MaDanhMuc) REFERENCES DanhMuc(MaDanhMuc),
    FOREIGN KEY (MaNguoiBan) REFERENCES NguoiDung(MaNguoiDung)
)

CREATE TABLE DonHang (
    MaDonHang INT PRIMARY KEY,
    MaNguoiDung INT,
    NgayDat DATETIME DEFAULT GETDATE(),
    TongTien DECIMAL(18,2),
    TrangThai NVARCHAR(50),
    FOREIGN KEY (MaNguoiDung) REFERENCES NguoiDung(MaNguoiDung)
)

CREATE TABLE ChiTietDonHang (
    MaDonHang INT,
    MaSanPham INT,
    SoLuong INT NOT NULL,
    Gia DECIMAL(18,2) NOT NULL,
    PRIMARY KEY (MaDonHang, MaSanPham),
    FOREIGN KEY (MaDonHang) REFERENCES DonHang(MaDonHang),
    FOREIGN KEY (MaSanPham) REFERENCES SanPham(MaSanPham)
)

CREATE INDEX IDX_SanPham_DanhMuc
ON SanPham(MaDanhMuc)

CREATE INDEX IDX_SanPham_NguoiBan
ON SanPham(MaNguoiBan)

CREATE INDEX IDX_SanPham_Gia
ON SanPham(Gia)

CREATE INDEX IDX_DonHang_NguoiDung
ON DonHang(MaNguoiDung)

CREATE INDEX IDX_DonHang_NgayDat
ON DonHang(NgayDat)

CREATE INDEX IDX_ChiTietDonHang_SanPham
ON ChiTietDonHang(MaSanPham)