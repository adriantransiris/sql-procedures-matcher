package org.sqlprocedures;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static org.sqlprocedures.SQLPatterns.*;

public class FileStringPatternReplacer {

    public static void main(String[] args) {
        // Replace these with your own file paths and pattern
        String inputFilePath = "input/12.1.0.4_to_12.1.4_REPORTS.sql";
        String outputFilePath = "output/12.1.0.4_to_12.1.4_REPORTS_OUT.sql";

        convert(inputFilePath, outputFilePath, CREATE_TABLE_Q, CREATE_TABLE_PROCEDURE);
//        convert(outputFilePath, outputFilePath, CREATE_TABLE_Q, CREATE_TABLE_PROCEDURE);
    }

    private static void convert(String inputFilePath, String outputFilePath,
                                String patternString, String replacementString) {
        // Read the file into a string
        String fileContents = readFileAsString(inputFilePath);

        // Create a pattern object from the pattern string
        Pattern pattern = Pattern.compile(patternString, Pattern.DOTALL);

        // Use a matcher to find all occurrences of the pattern in the file contents
        Matcher matcher = pattern.matcher(fileContents);

        // Loop through all the matches and replace them with a modified version of the match
        StringBuilder sb = new StringBuilder();
        while (matcher.find()) {
            String matchedString = matcher.group();

            String temp = replacementString;
            temp = temp.replace(TO_BE_REPLACED, matchedString.substring(0, matchedString.length() - 1));

            matcher.appendReplacement(sb, temp);
        }

        matcher.appendTail(sb);

        // Write the modified file contents to a new file
        writeFileAsString(outputFilePath, sb.toString());
    }

    private static String readFileAsString(String filePath) {
        String fileContents = "";
        try {
            Path path = Paths.get(filePath);
            byte[] bytes = Files.readAllBytes(path);
            fileContents = new String(bytes);
        } catch (IOException e) {
            e.printStackTrace();
        }

        return fileContents;
    }

    private static void writeFileAsString(String filePath, String content) {
        try {
            Path path = Paths.get(filePath);
            byte[] bytes = content.getBytes();
            Files.write(path, bytes, StandardOpenOption.CREATE);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

}
