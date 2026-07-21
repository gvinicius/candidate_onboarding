class CvTextExtractor
  def self.call(document)
    new(document).extract
  end

  def self.extract_from_upload(uploaded_file)
    new(nil).extract_from_path(uploaded_file.tempfile.path, uploaded_file.content_type)
  end

  def initialize(document)
    @document = document
  end

  def extract
    return @document.raw_text if @document.raw_text.present?

    blob = @document.file.blob
    @document.file.open { |tmp| extract_from_path(tmp.path, blob.content_type) }
  end

  def extract_from_path(path, content_type)
    case content_type
    when "application/pdf"
      extract_pdf(path)
    when "application/msword",
         "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
      extract_docx(path)
    else
      raise "Unsupported content type: #{content_type}"
    end
  end

  private

  def extract_pdf(path)
    reader = PDF::Reader.new(path)
    reader.pages.map(&:text).join("\n\n")
  rescue => e
    raise "PDF extraction failed: #{e.message}"
  end

  def extract_docx(path)
    doc = Docx::Document.open(path)
    doc.paragraphs.map(&:to_s).join("\n")
  rescue => e
    raise "DOCX extraction failed: #{e.message}"
  end
end
