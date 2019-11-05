// This class using for Currency Conversion
// Release -- FY'14 R3 Rel
public class CurrencyConvert
{
 
  public static String ToString(integer Value)
  {
      /* string representation if an Integer value */
      return Value.format();
  }
 
  public static String ToString(Double Value)
  {
    /* string representation if a Double value */
     return Value.format();
  }

  public static String ToString(Decimal Value)
  {
    /* string representation if a Decimal value */
    return Value.format();
  }
 
  public static String ToString(Decimal Value, Boolean ScientificNotation)
  {
    /* string representation if a Decimal value with or without Scientific Notation */
    if (ScientificNotation)
     return Value.format();
    else
     return Value.toPlainString();
  }
 
  
  public static String CurrencyToString(Decimal Value, String CurrencyChar)
  {
    Double conversionRate = [SELECT conversionrate FROM currencytype WHERE isocode =: CurrencyChar LIMIT 1].conversionRate;
     Double finalVal = Value*conversionRate;
     Long l = finalVal.round(); 
     return CurrencyChar +' '+ ToString(l);
  }
 
}