package com.analyzeme.parsers;

import java.io.IOException;
import java.io.InputStream;
import java.util.*;
import java.util.concurrent.SynchronousQueue;

import com.analyzeme.data.Data;
import com.analyzeme.data.DataArray;
import com.analyzeme.data.dataWithType.DataEntry;
import com.analyzeme.data.dataWithType.DataEntryType;
import com.analyzeme.data.dataWithType.DataWithType;
import com.analyzeme.data.dataWithType.DataWithTypeArray;
import org.apache.poi.EncryptedDocumentException;
import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.apache.poi.ss.usermodel.*;

/**
 * Created by ilya on 7/5/16.
 */
public class ExcelParser implements IParser {

    public DataArray<Double> parse(InputStream input) throws InvalidFileException {// Now works only with doubles
        DataArray<Double> result = new DataArray<Double>();

        try {
            Workbook workbook = WorkbookFactory.create(input);
            Sheet sheet = workbook.getSheetAt(0);

            int numColumns = sheet.getRow(0).getLastCellNum();
            List<String> columnNames = new ArrayList<String>();
            for (Cell titleCell : sheet.getRow(0)) {
                columnNames.add(titleCell.getStringCellValue());
            }
            for (Row row : sheet) {
                Map<String, Double> data = new HashMap<String, Double>();
                for (int c = 0; c < numColumns; c++) {
                    Cell cell = row.getCell(c);
                    Boolean isNumeric = cell != null && (cell.getCellType() == Cell.CELL_TYPE_NUMERIC
                            || (cell.getCellType() == Cell.CELL_TYPE_FORMULA && cell.getCachedFormulaResultType() == Cell.CELL_TYPE_NUMERIC));
                    if (isNumeric) {
                        data.put(columnNames.get(c), cell.getNumericCellValue());
                    }
                }
                if (!data.isEmpty()) {
                    result.addData(new Data<Double>(data));
                }
            }
        } catch (Exception e) {
            throw new InvalidFileException("Excel file is not valid!");
        }
        return result;
    }

    @Override
    public DataWithTypeArray parseWithType(InputStream input) throws InvalidFileException {
        DataWithTypeArray result = new DataWithTypeArray();

        try {
            Workbook workbook = WorkbookFactory.create(input);
            Sheet sheet = workbook.getSheetAt(0);

            int numColumns = sheet.getRow(0).getLastCellNum();
            List<String> columnNames = new ArrayList<>();
            for (Cell titleCell : sheet.getRow(0)) {
                columnNames.add(titleCell.getStringCellValue());
            }
            boolean isTitleRow = true;
            for (Row row : sheet) {
                if (isTitleRow) { //We need to skip title row
                    isTitleRow = false;
                    continue;
                }
                Map<String, DataEntry> data = new HashMap<>();
                for (int c = 0; c < numColumns; c++) {
                    Cell cell = row.getCell(c);
                    data.put(columnNames.get(c), getFromCell(cell));
                }
                if (!data.isEmpty()) {
                    result.addData(new DataWithType(data));
                }
            }
        } catch (IOException | InvalidFormatException | EncryptedDocumentException e) {
            throw new InvalidFileException("Excel file is not valid!");
        }
        return result;
    }

    private DataEntry getFromCell(Cell cell) {
        if (cell == null) {
            throw new IllegalArgumentException();
        }
        if (cell.getCellType() == Cell.CELL_TYPE_NUMERIC) {
            if (ExcelUtils.isCellTimeFormatted(cell)) {
                return new DataEntry(DataEntryType.TIME, ExcelUtils.getTimeFromExcelCell(cell));
            } else if (ExcelUtils.isCellDateFormated(cell)) {
                return new DataEntry(DataEntryType.DATE, ExcelUtils.getDateFormCell(cell));
            } else if (ExcelUtils.isCellDateTimeFormatted(cell)) {
                return new DataEntry(DataEntryType.DATE_TIME, ExcelUtils.getDateTimeFormCell(cell));
            } else {
                return new DataEntry(DataEntryType.DOUBLE, cell.getNumericCellValue());
            }

        } else if (cell.getCellType() == Cell.CELL_TYPE_FORMULA &&
                cell.getCachedFormulaResultType() == Cell.CELL_TYPE_NUMERIC) {
            return new DataEntry(DataEntryType.DOUBLE, cell.getNumericCellValue());
        } else if (cell.getCellType() == Cell.CELL_TYPE_STRING) {
            return new DataEntry(DataEntryType.STRING, cell.getStringCellValue());
        } else {
            throw new IllegalArgumentException("Cell type not supported!");
        }
    }
}
