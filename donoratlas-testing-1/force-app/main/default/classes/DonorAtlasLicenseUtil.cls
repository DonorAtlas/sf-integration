public class DonorAtlasLicenseUtil {
    /**
     * Returns TRUE in two cases:
     *  1. The PackageLicense object exists and is Active.
     *  2. In scratch/dev orgs where PackageLicense isn’t present.
     */
    public static Boolean isLicensed() {
        try {
            List<SObject> rows = Database.query(
                'SELECT Status FROM PackageLicense WHERE NamespacePrefix = \'donoratlas\' LIMIT 1');
            if (!rows.isEmpty()) {
                return (String)rows[0].get('Status') == 'Active';
            }
        } catch (Exception e) {
            // object doesn’t exist (scratch org) – allow execution
        }
        return true;
    }
}