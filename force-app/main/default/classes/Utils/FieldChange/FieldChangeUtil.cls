/**
 * Created by patryk.witkowski_bri on 5/30/2025.
 */

public class FieldChangeUtil {
    public static Boolean hasRecordValueChangedFromSpecificValue(SObject oldObject, SObject newObject, String fieldName, Object oldValue, Object newValue) {
        Object currentValue = newObject?.get(fieldName);
        Object previousValue = oldObject?.get(fieldName);

        return previousValue == oldValue && currentValue == newValue;
    }

    public static Boolean hasRecordValueChangedTo(SObject oldObject, SObject newObject, SObjectField fieldName, Object targetValue) {
        Object currentValue = newObject?.get(fieldName);
        Object previousValue = oldObject?.get(fieldName);
        return previousValue != targetValue && currentValue == targetValue;
    }
}