class CvTextExtractor
  def self.call(document)
    new(document).extract
  end

  def initialize(document)
    @document = document
  end

  def extract
    blob = @document.file.blob
    content_type = blob.content_type

    case content_type
    when "application/pdf"
      extract_pdf
    when "application/msword",
         "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
      extract_docx
    else
      raise "Unsupported content type: #{content_type}"
    end
  end

  private

  def extract_pdf
    @document.file.open do |tmp|
      reader = PDF::Reader.new(tmp.path)
      reader.pages.map(&:text).join("\n\n")
    end
  rescue => e
    raise "PDF extraction failed: #{e.message}"
  end

  def extract_docx
    @document.file.open do |tmp|
      doc  = Docx::Document.open(tmp.path)
      doc.paragraphs.map(&:to_s).join("\n")
    end
  rescue => e
    raise "DOCX extraction failed: #{e.message}"
  end
end
