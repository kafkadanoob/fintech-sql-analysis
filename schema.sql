CREATE TABLE users (
    user_id     INT PRIMARY KEY,
    name        VARCHAR(100),
    age         INT,
    city        VARCHAR(50),
    signup_date DATE,
    account_type VARCHAR(20)
);

CREATE TABLE categories (
    category_id   INT PRIMARY KEY,
    category_name VARCHAR(50)
);

CREATE TABLE transactions (
    transaction_id   INT PRIMARY KEY,
    user_id          INT REFERENCES users(user_id),
    amount           NUMERIC(10,2),
    transaction_date DATE,
    transaction_type VARCHAR(10),
    status           VARCHAR(15)
);

CREATE TABLE transaction_categories (
    transaction_id INT REFERENCES transactions(transaction_id),
    category_id    INT REFERENCES categories(category_id),
    PRIMARY KEY (transaction_id, category_id)
);
