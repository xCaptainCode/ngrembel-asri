-- ------------------------------------------------------------
-- Seed script: 50 dummy rows for the `members` table
-- ------------------------------------------------------------
-- Run this script with: psql -U <db_user> -d ngrembel_asri -f seed-members.sql
-- ------------------------------------------------------------

INSERT INTO members (nama, no_hp, email, password)
VALUES
    ('Alice Anderson',      '08120000001', 'alice.anderson@example.com',      crypt('password123', gen_salt('bf'))),
    ('Bob Brown',           '08120000002', 'bob.brown@example.com',           crypt('password123', gen_salt('bf'))),
    ('Charlie Clark',       '08120000003', 'charlie.clark@example.com',       crypt('password123', gen_salt('bf'))),
    ('Diana Davis',         '08120000004', 'diana.davis@example.com',         crypt('password123', gen_salt('bf'))),
    ('Ethan Evans',         '08120000005', 'ethan.evans@example.com',         crypt('password123', gen_salt('bf'))),
    ('Fiona Fisher',        '08120000006', 'fiona.fisher@example.com',        crypt('password123', gen_salt('bf'))),
    ('George Gray',         '08120000007', 'george.gray@example.com',         crypt('password123', gen_salt('bf'))),
    ('Hannah Hall',         '08120000008', 'hannah.hall@example.com',         crypt('password123', gen_salt('bf'))),
    ('Ian Irving',          '08120000009', 'ian.irving@example.com',          crypt('password123', gen_salt('bf'))),
    ('Julia Jones',         '08120000010', 'julia.jones@example.com',         crypt('password123', gen_salt('bf'))),

    ('Kevin Kelly',         '08120000011', 'kevin.kelly@example.com',         crypt('password123', gen_salt('bf'))),
    ('Laura Lee',           '08120000012', 'laura.lee@example.com',           crypt('password123', gen_salt('bf'))),
    ('Mike Miller',         '08120000013', 'mike.miller@example.com',         crypt('password123', gen_salt('bf'))),
    ('Nina Novak',          '08120000014', 'nina.novak@example.com',          crypt('password123', gen_salt('bf'))),
    ('Oscar Owens',         '08120000015', 'oscar.owens@example.com',         crypt('password123', gen_salt('bf'))),
    ('Paula Patel',         '08120000016', 'paula.patel@example.com',         crypt('password123', gen_salt('bf'))),
    ('Quentin Quinn',       '08120000017', 'quentin.quinn@example.com',       crypt('password123', gen_salt('bf'))),
    ('Rachel Reed',         '08120000018', 'rachel.reed@example.com',         crypt('password123', gen_salt('bf'))),
    ('Samir Singh',         '08120000019', 'samir.singh@example.com',         crypt('password123', gen_salt('bf'))),
    ('Tina Turner',         '08120000020', 'tina.turner@example.com',         crypt('password123', gen_salt('bf'))),

    ('Uma Ulrich',          '08120000021', 'uma.ulrich@example.com',          crypt('password123', gen_salt('bf'))),
    ('Victor Vega',         '08120000022', 'victor.vega@example.com',         crypt('password123', gen_salt('bf'))),
    ('Wendy Wu',            '08120000023', 'wendy.wu@example.com',            crypt('password123', gen_salt('bf'))),
    ('Xander Xiong',        '08120000024', 'xander.xiong@example.com',        crypt('password123', gen_salt('bf'))),
    ('Yara Yusuf',          '08120000025', 'yara.yusuf@example.com',          crypt('password123', gen_salt('bf'))),
    ('Zack Zimmerman',      '08120000026', 'zack.zimmerman@example.com',      crypt('password123', gen_salt('bf'))),
    ('Aaliyah Ahmed',       '08120000027', 'aaliyah.ahmed@example.com',       crypt('password123', gen_salt('bf'))),
    ('Benny Baker',         '08120000028', 'benny.baker@example.com',         crypt('password123', gen_salt('bf'))),
    ('Catherine Chen',      '08120000029', 'catherine.chen@example.com',      crypt('password123', gen_salt('bf'))),
    ('Derek Diaz',          '08120000030', 'derek.diaz@example.com',          crypt('password123', gen_salt('bf'))),

    ('Evelyn Edwards',      '08120000031', 'evelyn.edwards@example.com',      crypt('password123', gen_salt('bf'))),
    ('Frank Flynn',         '08120000032', 'frank.flynn@example.com',         crypt('password123', gen_salt('bf'))),
    ('Grace Gomez',         '08120000033', 'grace.gomez@example.com',         crypt('password123', gen_salt('bf'))),
    ('Harold Hall',         '08120000034', 'harold.hall@example.com',         crypt('password123', gen_salt('bf'))),
    ('Irene Ibarra',        '08120000035', 'irene.ibarra@example.com',        crypt('password123', gen_salt('bf'))),
    ('Jack Jackson',        '08120000036', 'jack.jackson@example.com',        crypt('password123', gen_salt('bf'))),
    ('Karen Kim',           '08120000037', 'karen.kim@example.com',           crypt('password123', gen_salt('bf'))),
    ('Leon Liu',            '08120000038', 'leon.liu@example.com',            crypt('password123', gen_salt('bf'))),
    ('Mona Martinez',       '08120000039', 'mona.martinez@example.com',       crypt('password123', gen_salt('bf'))),
    ('Nolan Nolan',         '08120000040', 'nolan.nolan@example.com',         crypt('password123', gen_salt('bf'))),

    ('Olivia Ortiz',        '08120000041', 'olivia.ortiz@example.com',        crypt('password123', gen_salt('bf'))),
    ('Peter Patel',         '08120000042', 'peter.patel@example.com',         crypt('password123', gen_salt('bf'))),
    ('Queenie Quinn',       '08120000043', 'queenie.quinn@example.com',       crypt('password123', gen_salt('bf'))),
    ('Rafael Ramos',        '08120000044', 'rafael.ramos@example.com',        crypt('password123', gen_salt('bf'))),
    ('Sabrina Singh',       '08120000045', 'sabrina.singh@example.com',       crypt('password123', gen_salt('bf'))),
    ('Tommy Tan',           '08120000046', 'tommy.tan@example.com',           crypt('password123', gen_salt('bf'))),
    ('Ursula Ueda',         '08120000047', 'ursula.ueda@example.com',         crypt('password123', gen_salt('bf'))),
    ('Victor Vang',         '08120000048', 'victor.vang@example.com',         crypt('password123', gen_salt('bf'))),
    ('Wanda Wu',            '08120000049', 'wanda.wu@example.com',            crypt('password123', gen_salt('bf'))),
    ('Xenia Xu',            '08120000050', 'xenia.xu@example.com',            crypt('password123', gen_salt('bf')));
