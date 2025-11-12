import mysql from "mysql2/promise";
import { setupDatabase } from "../db/connect";

async function clearDatabase() {
    const db = await setupDatabase();

    // Get all table names
    const result = await db.execute(`
    SELECT TABLE_NAME
    FROM information_schema.TABLES
    WHERE TABLE_SCHEMA = DATABASE();
  `);

    // result[0] is the rows array
    const tables = (result[0] as unknown) as { TABLE_NAME: string }[];

    if (tables.length === 0) {
        console.log("No tables found to drop.");
        await (db.$client as mysql.Pool).end();
        return;
    }

    await db.execute(`SET FOREIGN_KEY_CHECKS = 0;`);

    for (const row of tables) {
        const tableName = row.TABLE_NAME;
        console.log(`Dropping table: ${tableName}`);
        await db.execute(`DROP TABLE IF EXISTS \`${tableName}\`;`);
    }

    await db.execute(`SET FOREIGN_KEY_CHECKS = 1;`);

    console.log("✅ All tables dropped.");
    await (db.$client as mysql.Pool).end();
}

clearDatabase().catch((e) => {
    console.error("Failed to clear database:", e);
    process.exit(1);
});
