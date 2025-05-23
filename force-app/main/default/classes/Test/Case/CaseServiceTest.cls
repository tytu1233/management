/**
 * Created by patryk.witkowski_bri on 5/23/2025.
 */

@IsTest
public class CaseServiceTest {

    @TestSetup
    static void setup() {
        new DataGenerator().createData();
    }

    class DataGenerator extends Factory {
        public override void createData() {

        }
    }
}