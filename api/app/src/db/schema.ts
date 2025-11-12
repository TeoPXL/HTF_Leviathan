import { sql } from "drizzle-orm"
import {
    mysqlTable,
    varchar,
    int,
    datetime,
    text,
    boolean,
    unique,
    mysqlEnum,
} from 'drizzle-orm/mysql-core'

//types
export const userThemeEnum = mysqlEnum('theme', ['dark', 'light'])
export const fontSizeEnum = mysqlEnum('font_size', ['small', 'default', 'large'])
export const queueStatusEnum = mysqlEnum('status', ['pending', 'ready', 'approved', 'removed', 'restricted'])
export const subtitleTypeEnum = mysqlEnum('subtitle_type', ['auto_generated', 'commissioned'])
export const roleEnum = mysqlEnum('role', ['user', 'moderator', 'admin'])
