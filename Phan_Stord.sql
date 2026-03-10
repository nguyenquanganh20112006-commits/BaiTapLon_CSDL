USE Quanlybanquanao
GO

CREATE PROCEDURE sp_ThemSanPham
    @TenSP NVARCHAR(100),
    @Gia DECIMAL(18,2),
    @SoLuong INT,
    @MaDanhMuc INT
AS
BEGIN
    INSERT INTO SanPham(TenSanPham, Gia, SoLuongTon, MaDanhMuc)
    VALUES (@TenSP, @Gia, @SoLuong, @MaDanhMuc);
END
GO



CREATE PROCEDURE sp_SuaSanPham
    @MaSanPham INT,
    @TenSP NVARCHAR(100),
    @Gia DECIMAL(18,2)
AS
BEGIN
    UPDATE SanPham
    SET TenSanPham = @TenSP,
        Gia = @Gia
    WHERE MaSanPham = @MaSanPham;
END
GO



CREATE PROCEDURE sp_TimSanPham
    @TenSP NVARCHAR(100)
AS
BEGIN
    SELECT *
    FROM v_SanPham
    WHERE TenSanPham LIKE N'%' + @TenSP + N'%';
END
GO



EXEC sp_ThemSanPham N'Áo thun',150000,10,1
EXEC sp_ThemSanPham N'Quần jean',350000,5,1
EXEC sp_ThemSanPham N'Áo khoác',500000,3,2



SELECT * FROM SanPham



EXEC sp_TimSanPham N'áo'



EXEC sp_SuaSanPham 1,N'Áo thun cotton',180000

