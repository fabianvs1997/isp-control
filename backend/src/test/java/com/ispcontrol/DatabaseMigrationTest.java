package com.ispcontrol;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.jdbc.core.JdbcTemplate;

import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
class DatabaseMigrationTest {

    @Autowired JdbcTemplate jdbc;

    @Test
    void postgisAndCoreTablesExist() {
        Integer postgis = jdbc.queryForObject(
            "SELECT count(*) FROM pg_extension WHERE extname = 'postgis'", Integer.class);
        assertEquals(1, postgis);

        for (String table : new String[]{"customers", "service_plans", "installations",
                "subscriptions", "charges", "payments", "payment_allocations", "service_areas"}) {
            Integer count = jdbc.queryForObject(
                "SELECT count(*) FROM information_schema.tables WHERE table_schema = 'public' AND table_name = ?",
                Integer.class, table);
            assertEquals(1, count, table);
        }
    }

    @Test
    void installationCannotBelongToDifferentSubscriptionCustomer() {
        UUID customerA = UUID.randomUUID(), customerB = UUID.randomUUID();
        UUID installation = UUID.randomUUID(), plan = UUID.randomUUID();
        jdbc.update("INSERT INTO customers (id, full_name) VALUES (?, 'Customer A'), (?, 'Customer B')",
            customerA, customerB);
        jdbc.update("INSERT INTO service_plans (id, name, monthly_price) VALUES (?, 'Basic', 350.00)", plan);
        jdbc.update("INSERT INTO installations (id, customer_id, address, access_technology) VALUES (?, ?, 'Address', 'FIBER')",
            installation, customerA);

        assertThrows(org.springframework.dao.DataIntegrityViolationException.class,
            () -> jdbc.update("""
                INSERT INTO subscriptions
                (customer_id, installation_id, plan_id, agreed_monthly_price, billing_day, start_date)
                VALUES (?, ?, ?, 350.00, 10, CURRENT_DATE)
                """, customerB, installation, plan));
    }

    @Test
    void duplicateMonthlyChargeIsRejected() {
        UUID customer = UUID.randomUUID(), installation = UUID.randomUUID();
        UUID plan = UUID.randomUUID(), subscription = UUID.randomUUID();
        jdbc.update("INSERT INTO customers(id, full_name) VALUES (?, 'Charge Test')", customer);
        jdbc.update("INSERT INTO service_plans(id, name, monthly_price) VALUES (?, 'Monthly', 350)", plan);
        jdbc.update("INSERT INTO installations(id, customer_id, address, access_technology) VALUES (?, ?, 'Address', 'WIRELESS')",
            installation, customer);
        jdbc.update("""
            INSERT INTO subscriptions(id, customer_id, installation_id, plan_id, agreed_monthly_price, billing_day, start_date)
            VALUES (?, ?, ?, ?, 350, 10, CURRENT_DATE)
            """, subscription, customer, installation, plan);
        jdbc.update("""
            INSERT INTO charges(subscription_id, period_start, due_date, amount)
            VALUES (?, DATE '2026-10-01', DATE '2026-10-10', 350)
            """, subscription);
        assertThrows(org.springframework.dao.DuplicateKeyException.class,
            () -> jdbc.update("""
                INSERT INTO charges(subscription_id, period_start, due_date, amount)
                VALUES (?, DATE '2026-10-01', DATE '2026-10-10', 350)
                """, subscription));
    }
}
