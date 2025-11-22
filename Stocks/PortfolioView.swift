//
//  PortfolioView.swift
//  Stocks
//
//  Created by Tahren Ponnusamy on 4/11/2025.
//

import SwiftUI
import SwiftData

struct PortfolioView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [SortDescriptor<StockHolding>(\.date, order: .reverse)]) private var holdings: [StockHolding]

    var body: some View {
        TabView {
            PortfolioChartView(holdings: holdings)
            PortfolioListView()
        }
        .tabViewStyle(.page)
    }
    
}

#Preview {
    PortfolioView()
}

func addTemplateHoldingsV2(using context: ModelContext) {
    var holdings: [StockHolding] = []
    for holding in myHoldings {
        let holdingDate = parseHoldingDate(holding[0])
        if holding[1] == "RSU" {
            let numberOfShares: Decimal = Decimal(string: holding[4]) ?? 0.0
            holdings.append(StockHolding(transactionDate: holdingDate, type: .rsu, rsuPack: Int(holding[2]), purchasePrice: 0.0, numberOfShares: numberOfShares))
        } else {
            let purchasePrice = Decimal(string: String(holding[3].dropFirst())) ?? 0.0
            let numberOfShares: Decimal = Decimal(string: holding[4]) ?? 0.0
            if holding[1] == "ESPP" {
                holdings.append(StockHolding(transactionDate: holdingDate, type: .espp, purchasePrice: purchasePrice, numberOfShares: numberOfShares))
            } else {
                holdings.append(StockHolding(transactionDate: holdingDate, type: .dividends, purchasePrice: purchasePrice, numberOfShares: numberOfShares))
            }
        }
    }
    holdings.sort { $0.date < $1.date }
    for holding in holdings {
        context.insert(holding)
    }
    try? context.save()
}

let myHoldings = [
    ["31 Jan 2016","ESPP","","$20.68","60"],
    ["31 Jul 2016","ESPP","","$20.49","48"],
    ["15 Oct 2016","RSU","1","$0.00","16"],
    ["31 Jan 2017","ESPP","","$22.54","68"],
    ["31 Jul 2017","ESPP","","$27.36","44"],
    ["15 Oct 2017","RSU","1","$0.00","12"],
    ["15 Oct 2017","RSU","2","$0.00","24"],
    ["31 Jan 2018","ESPP","","$31.89","48"],
    ["31 Jul 2018","ESPP","","$35.65","48"],
    ["15 Oct 2018","RSU","1","$0.00","12"],
    ["15 Oct 2018","RSU","2","$0.00","24"],
    ["15 Oct 2018","RSU","3","$0.00","20"],
    ["31 Jan 2019","ESPP","","$35.37","56"],
    ["15 Apr 2019","RSU","4","$0.00","20"],
    ["31 Jul 2019","ESPP","","$35.39","48"],
    ["15 Oct 2019","RSU","2","$0.00","24"],
    ["15 Oct 2019","RSU","3","$0.00","16"],
    ["15 Oct 2019","RSU","5","$0.00","12"],
    ["31 Jan 2020","ESPP","","$44.29","52"],
    ["15 Apr 2020","RSU","4","$0.00","20"],
    ["31 Jul 2020","ESPP","","$65.59","24"],
    ["15 Oct 2020","RSU","3","$0.00","16"],
    ["15 Oct 2020","RSU","5","$0.00","12"],
    ["15 Oct 2020","RSU","6","$0.00","16"],
    ["31 Jan 2021","ESPP","","$92.60","27"],
    ["10 Feb 2022","Dividends","","$174.28","0.823"],
    ["12 May 2022","Dividends","","$142.02","1.057"],
    ["11 Aug 2022","Dividends","","$170.24","0.883"],
    ["10 Nov 2022","Dividends","","$143.46","1.049"],
    ["16 Feb 2023","Dividends","","$154.41","0.976"],
    ["18 May 2023","Dividends","","$173.40","0.908"],
    ["17 Aug 2023","Dividends","","$174.95","0.901"],
    ["16 Nov 2023","Dividends","","$188.54","0.837"],
    ["15 Feb 2024","Dividends","","$183.70","0.86"],
    ["16 May 2024","Dividends","","$189.59","0.869"],
    ["15 Aug 2024","Dividends","","$221.09","0.746"],
    ["14 Nov 2024","Dividends","","$223.71","0.738"],
    ["13 Feb 2025","Dividends","","$234.07","0.706"],
    ["15 May 2025","Dividends","","$212.88","0.808"],
    ["14 Aug 2025","Dividends","","$232.69","0.74"]
]

