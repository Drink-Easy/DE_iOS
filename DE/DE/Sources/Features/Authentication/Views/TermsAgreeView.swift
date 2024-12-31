import UIKit
import SnapKit
import CoreModule

class TermsAgreeView: UIView {
    
    // MARK: - UI Components
    private let titleLabel = UILabel()
    private let moreButton = UIButton(type: .system)
    private let toggleButton = UIButton(type: .system)
    
    // MARK: - Properties
    var onStateChange: ((Bool) -> Void)? // 상태 변경 시 호출되는 클로저
    
    private var pdfFileName: String?
    private weak var parentViewController: UIViewController?
    
    private var isChecked: Bool = false
    
    // MARK: - Initializer
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        titleLabel.font = UIFont.ptdSemiBoldFont(ofSize: 16)
        titleLabel.numberOfLines = 1
        titleLabel.textColor = .black
        
        moreButton.setTitle("보기", for: .normal)
        moreButton.setTitleColor(AppColor.gray50, for: .normal)
        moreButton.titleLabel?.font = UIFont.ptdSemiBoldFont(ofSize: 12)
        moreButton.addTarget(self, action: #selector(showPDF), for: .touchUpInside)
        
        toggleButton.tintColor = AppColor.gray30
        toggleButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        toggleButton.addTarget(self, action: #selector(toggleButtonTapped), for: .touchUpInside)
        
        [titleLabel, moreButton, toggleButton].forEach {
            addSubview($0)
        }
        
        toggleButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(30)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(toggleButton.snp.trailing).offset(10)
            make.centerY.equalTo(toggleButton)
        }
        
        moreButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(30)
            make.centerY.equalTo(toggleButton)
        }
    }
    
    // MARK: - Configuration
    func configure(title: String, moreLink: String?, isChecked: Bool, parentViewController: UIViewController) {
        titleLabel.text = title
        pdfFileName = moreLink
        self.isChecked = isChecked
        self.parentViewController = parentViewController
        updateToggleButton()
    }
    
    // MARK: - Methods
    @objc private func toggleButtonTapped() {
        isChecked.toggle()
        updateToggleButton()
        onStateChange?(isChecked)
    }
    
    func setChecked(isChecked: Bool) {
        self.isChecked = isChecked
        updateToggleButton()
    }
    
    private func updateToggleButton() {
        let imageName = isChecked ? "checkmark.circle.fill" : "checkmark.circle.fill"
        toggleButton.setImage(UIImage(systemName: imageName), for: .normal)
        toggleButton.tintColor = isChecked ? AppColor.purple100 : AppColor.gray30
    }
    
    @objc private func showPDF() {
        guard let fileName = pdfFileName, let parentVC = parentViewController else {
            print("PDF 파일이 없거나 부모 뷰 컨트롤러가 설정되지 않았습니다.")
            return
        }
        
        if let filePath = Bundle.main.path(forResource: fileName, ofType: "pdf") {
            let fileURL = URL(fileURLWithPath: filePath)
            let documentController = UIDocumentInteractionController(url: fileURL)
            documentController.delegate = parentVC as? UIDocumentInteractionControllerDelegate
            documentController.presentPreview(animated: true)
        } else {
            print("PDF 파일을 찾을 수 없습니다: \(pdfFileName ?? "없음")")
        }
    }
}
