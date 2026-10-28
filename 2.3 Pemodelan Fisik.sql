USE nexora_education;

CREATE TABLE kategori_kerusakan (
  id_kategori        INT AUTO_INCREMENT PRIMARY KEY,
  nama_kategori      VARCHAR(100) NOT NULL UNIQUE,
  prioritas_default  ENUM('rendah','sedang','tinggi') NOT NULL DEFAULT 'sedang'
) ENGINE=InnoDB;

CREATE TABLE tiket_kerusakan (
  id_tiket       BIGINT AUTO_INCREMENT PRIMARY KEY,
  id_perangkat   INT NOT NULL,
  id_pelapor     INT NOT NULL,
  id_kategori    INT NOT NULL,
  id_penangan    INT NULL,                       -- admin_it yang menangani
  deskripsi      VARCHAR(500) NOT NULL,
  prioritas      ENUM('rendah','sedang','tinggi') NOT NULL DEFAULT 'sedang',
  status         ENUM('baru','diproses','selesai','ditolak') NOT NULL DEFAULT 'baru',
  waktu_lapor    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  waktu_selesai  DATETIME NULL,
  CONSTRAINT fk_tiket_perangkat FOREIGN KEY (id_perangkat)
    REFERENCES perangkat(id_perangkat) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_tiket_pelapor FOREIGN KEY (id_pelapor)
    REFERENCES pengguna(id_pengguna) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_tiket_kategori FOREIGN KEY (id_kategori)
    REFERENCES kategori_kerusakan(id_kategori) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_tiket_penangan FOREIGN KEY (id_penangan)
    REFERENCES admin_it(id_pengguna) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT ck_tiket_waktu CHECK (waktu_selesai IS NULL OR waktu_selesai >= waktu_lapor)
) ENGINE=InnoDB;

-- Entitas lemah: PK gabungan (id_tiket + waktu_catatan)
CREATE TABLE riwayat_tiket (
  id_tiket       BIGINT NOT NULL,
  waktu_catatan  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status_baru    ENUM('baru','diproses','selesai','ditolak') NOT NULL,
  catatan        VARCHAR(255),
  id_pengguna    INT NOT NULL,
  PRIMARY KEY (id_tiket, waktu_catatan),
  CONSTRAINT fk_riwayat_tiket FOREIGN KEY (id_tiket)
    REFERENCES tiket_kerusakan(id_tiket) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_riwayat_pengguna FOREIGN KEY (id_pengguna)
    REFERENCES pengguna(id_pengguna) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE INDEX idx_tiket_status ON tiket_kerusakan (status, prioritas);

-- Perbaikan tabel lama: sesi_login belum punya CHECK urutan waktu
ALTER TABLE sesi_login
  ADD CONSTRAINT ck_sesi_waktu CHECK (waktu_logout IS NULL OR waktu_logout >= waktu_login);

DELIMITER $$
CREATE TRIGGER trg_tiket_ai AFTER INSERT ON tiket_kerusakan
FOR EACH ROW
BEGIN
  UPDATE perangkat SET status = 'bermasalah' WHERE id_perangkat = NEW.id_perangkat;
END$$

CREATE TRIGGER trg_tiket_au AFTER UPDATE ON tiket_kerusakan
FOR EACH ROW
BEGIN
  IF NEW.status = 'selesai' AND OLD.status <> 'selesai' THEN
    UPDATE perangkat SET status = 'offline' WHERE id_perangkat = NEW.id_perangkat;
  END IF;
END$$
DELIMITER ;
