// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import Network


public class ChangeGraphViewController: UIViewController {
    
    let recordGraphView = ChangeGraphView()
    private var sliderValues: [String: Int] = [:] {
        didSet {
            updatePolygonChart()
        }
    }
    let navigationBarManager = NavigationBarManager()
    
    let noteService = TastingNoteService()
    let dto: TastingNoteResponsesDTO
    
    init(dto: TastingNoteResponsesDTO) {
        self.dto = dto
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recordGraphView.updateUI(dto: dto)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view = recordGraphView
        setupActions()
        setupNavigationBar()
        saveSliderValues()
        updatePolygonChart()
    }
    
    func setupActions() {
        recordGraphView.nextButton.addTarget(self, action: #selector(nextVC), for: .touchUpInside)
        
        recordGraphView.sweetSlider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        recordGraphView.acidSlider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        recordGraphView.tanninSlider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        recordGraphView.bodySlider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        recordGraphView.alcoholSlider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
    }
    
    private func setupNavigationBar() {
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(prevVC),
            tintColor: AppColor.gray80!
        )
    }
    
    private func updatePolygonChart() {
        let chartData = [
            RadarChartData(type: .sweetness, value: sliderValues["Sweetness"] ?? 0),
            RadarChartData(type: .acid, value: sliderValues["Acidity"] ?? 0),
            RadarChartData(type: .tannin, value: sliderValues["Tannin"] ?? 0),
            RadarChartData(type: .bodied, value: sliderValues["Body"] ?? 0),
            RadarChartData(type: .alcohol, value: sliderValues["Alcohol"] ?? 0)
        ]
        
        // 다각형 차트에 데이터 설정
        recordGraphView.polygonChart.dataList = chartData
    }

    @objc func prevVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func nextVC() {
        saveSliderValues()
        dismiss(animated: true, completion: nil)
    }
    
    private func saveSliderValues() {
        // RecordGraphView의 슬라이더 값을 가져옴
        sliderValues["Sweetness"] = Int(recordGraphView.sweetSlider.value)
        sliderValues["Acidity"] = Int(recordGraphView.acidSlider.value)
        sliderValues["Tannin"] = Int(recordGraphView.tanninSlider.value)
        sliderValues["Body"] = Int(recordGraphView.bodySlider.value)
        sliderValues["Alcohol"] = Int(recordGraphView.alcoholSlider.value)
        
        callNotePatchGraph(
            sugar: sliderValues["Sweetness"] ?? 20,
            acid: sliderValues["Acidity"] ?? 20,
            tannin: sliderValues["Tannin"] ?? 20,
            body: sliderValues["Body"] ?? 20,
            alcohol: sliderValues["Alcohol"] ?? 20
        )
    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        switch sender {
        case recordGraphView.sweetSlider:
            sliderValues["Sweetness"] = Int(sender.value)
        case recordGraphView.acidSlider:
            sliderValues["Acidity"] = Int(sender.value)
        case recordGraphView.tanninSlider:
            sliderValues["Tannin"] = Int(sender.value)
        case recordGraphView.bodySlider:
            sliderValues["Body"] = Int(sender.value)
        case recordGraphView.alcoholSlider:
            sliderValues["Alcohol"] = Int(sender.value)
        default:
            break
        }
    }
    
    func callNotePatchGraph(sugar: Int, acid: Int, tannin: Int, body: Int, alcohol: Int) {
        let updateRequest = TastingNoteUpdateRequestDTO(
            color: nil,
            tastingDate: nil,
            sugarContent: sugar,
            acidity: acid,
            tannin: tannin,
            body: body,
            alcohol: alcohol,
            addNoseList: nil,
            removeNoseList: nil,
            rating: nil,
            review: nil
        )
        let patchDTO = TastingNotePatchRequestDTO(noteId: dto.noteId, body: updateRequest)
        noteService.patchNote(data: patchDTO, completion: {[weak self] result in
            guard let self = self else { return }
            switch result {
            case.success(let response):
                DispatchQueue.main.async {
                    print("PATCH 요청 성공: \(response)")
                }
            case.failure(let error):
                print(error)
            }
        })
    }
}
