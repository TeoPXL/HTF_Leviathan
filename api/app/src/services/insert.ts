// /services/insert.ts
import mysql from "mysql2/promise";
import { dbConfig } from "../db/config";
import { readFileSync } from "fs";
import { resolve } from "path";

export async function executeSqlFile(filePath: string) {
    const sqlFilePath = resolve(filePath);
    const sql = readFileSync(sqlFilePath, "utf-8");

    const connection = await mysql.createConnection({
        ...dbConfig,
        multipleStatements: true, // ← critical
    });

    try {
        await connection.query(sql);
        console.log(`✅ Successfully executed SQL file: ${filePath}`);
    } catch (err) {
        console.error(`❌ Failed to execute SQL file: ${filePath}`, err);
        throw err;
    } finally {
        await connection.end();
    }
}

// Run directly
if (import.meta.main) {
    executeSqlFile("./src/assets/test.sql").catch((e) => process.exit(1));
    executeSqlFile("./src/assets/test2.sql").catch((e) => process.exit(1));
    executeSqlFile("./src/assets/test3.sql").catch((e) => process.exit(1));
    executeSqlFile("./src/assets/big.sql").catch((e) => process.exit(1));
}
