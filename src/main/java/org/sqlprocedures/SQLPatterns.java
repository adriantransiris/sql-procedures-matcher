package org.sqlprocedures;

public class SQLPatterns {
    public static String TO_BE_REPLACED = "@#$%^&*";

    public static String CREATE_TABLE_Q = "CREATE\\s+TABLE\\s+.*?;";
    public static String CREATE_TABLE_PROCEDURE =
            "declare begin execute immediate '" +
            TO_BE_REPLACED + "';\n" +
            "exception when others then\n" +
            "if SQLCODE = -955 then null; else raise; end if;\n" +
            "   commit;\n" +
            "end;\n" +
            "/";
}
